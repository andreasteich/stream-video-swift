//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import AVFoundation
import Combine
import StreamVideo
import SwiftUI

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}

@MainActor
public class LobbyViewModel: ObservableObject, @unchecked Sendable {
    private let camera: Any
    private var imagesTask: Task<Void, Never>?
    private var joinEventsTask: Task<Void, Never>?
    private var leaveEventsTask: Task<Void, Never>?
    
    @Published public var viewfinderImage: Image?
    @Published public var participants = [User]()
    
    private let call: Call
    
    public init(callType: String, callId: String, applyFilter: ((CIImage) async -> (CIImage))? = nil) {
        call = InjectedValues[\.streamVideo].call(
            callType: callType,
            callId: callId
        )
        if #available(iOS 14, *) {
            camera = Camera()
            imagesTask = Task {
                await handleCameraPreviews(applyFilter: applyFilter)
            }
        } else {
            camera = NSObject()
        }
        loadCurrentMembers()
        subscribeForCallJoinUpdates()
        subscribeForCallLeaveUpdates()
    }
    
    @available(iOS 14, *)
    func handleCameraPreviews(applyFilter: ((CIImage) async -> (CIImage))? = nil) async {
        guard let previewStream = (camera as? Camera)?.previewStream else { return }
            
        for await ciImage in previewStream.dropFirst() {
            let processedImage: CIImage
            
            if let applyFilter = applyFilter {
                processedImage = await applyFilter(ciImage)
            } else {
                processedImage = ciImage
            }
            
            await MainActor.run {
                viewfinderImage = processedImage.image
            }
        }
    }
    
    public func startCamera(front: Bool) {
        if #available(iOS 14, *) {
            if front {
                (camera as? Camera)?.switchCaptureDevice()
            }
            Task {
                await(camera as? Camera)?.start()
            }
        }
    }
    
    public func stopCamera() {
        imagesTask?.cancel()
        imagesTask = nil
        if #available(iOS 14, *) {
            (camera as? Camera)?.stop()
        }
    }
    
    public func cleanUp() {
        joinEventsTask?.cancel()
        joinEventsTask = nil
        leaveEventsTask?.cancel()
        leaveEventsTask = nil
    }
    
    // MARK: - private
    
    private func loadCurrentMembers() {
        Task {
            do {
                let response = try await call.get()
                withAnimation {
                    participants = response.call.session?.participants.map(\.user.toUser) ?? []
                }
            } catch {
                log.error(error)
            }
        }
    }
    
    private func subscribeForCallJoinUpdates() {
        joinEventsTask = Task {
            for await event in call.subscribe(for: CallSessionParticipantJoinedEvent.self) {
                let user = event.participant.user.toUser
                withAnimation {
                    participants.append(user)
                }
            }
        }
    }
    
    private func subscribeForCallLeaveUpdates() {
        leaveEventsTask = Task {
            for await event in call.subscribe(for: CallSessionParticipantLeftEvent.self) {
                let user = event.participant.user.toUser
                var indexToRemove: Int?
                for (index, participant) in participants.enumerated() {
                    if participant.id == user.id {
                        indexToRemove = index
                        break
                    }
                }
                withAnimation {
                    if let indexToRemove {
                        participants.remove(at: indexToRemove)
                    }
                }
            }
        }
    }
}

extension Image: @unchecked Sendable {}

private extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
