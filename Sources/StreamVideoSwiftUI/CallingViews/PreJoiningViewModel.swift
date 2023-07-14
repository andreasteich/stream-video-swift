//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import AVFoundation
import StreamVideo
import SwiftUI

@MainActor
public class LobbyViewModel: ObservableObject, @unchecked Sendable {
    private let camera: Any
    private var imagesTask: Task<Void, Never>?
    private var joinEventsTask: Task<Void, Never>?
    private var leaveEventsTask: Task<Void, Never>?
    
    @Published public var viewfinderImage: Image?
    @Published public var participants = [User]()
    
    private let call: Call
    
    public init(callType: String, callId: String) {
        self.call = InjectedValues[\.streamVideo].call(
            callType: callType,
            callId: callId
        )
        if #available(iOS 14, *) {
            camera = Camera()
            imagesTask = Task {
                await handleCameraPreviews()
            }
        } else {
            camera = NSObject()
        }
        loadCurrentMembers()
        subscribeForCallJoinUpdates()
        subscribeForCallLeaveUpdates()
    }
    
    @available(iOS 14, *)
    func handleCameraPreviews() async {
        let imageStream = (camera as? Camera)?.previewStream.dropFirst()
            .map(\.image)
        
        guard let imageStream = imageStream else { return }

        for await image in imageStream {
            await MainActor.run {
                viewfinderImage = image
            }
        }
    }
    
    public func startCamera(front: Bool) {
        if #available(iOS 14, *) {
            Task {
                await (camera as? Camera)?.start()
                if front {
                    (camera as? Camera)?.switchCaptureDevice()
                }
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
    
    // MARK: - private
    
    private func loadCurrentMembers() {
        Task {
            let response = try await call.get()
            withAnimation {
                participants = response.session?.participants.map { $0.user.toUser } ?? []
            }
        }
    }
    
    private func subscribeForCallJoinUpdates() {
        joinEventsTask = Task {
            for await event in call.subscribe(for: CallSessionParticipantJoinedEvent.self) {
                let user = event.user.toUser
                withAnimation {
                    participants.append(user)
                }
            }
        }
    }
    
    private func subscribeForCallLeaveUpdates() {
        leaveEventsTask = Task {
            for await event in call.subscribe(for: CallSessionParticipantLeftEvent.self) {
                let user = event.user.toUser
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
    
    deinit {
        joinEventsTask?.cancel()
        joinEventsTask = nil
        leaveEventsTask?.cancel()
        leaveEventsTask = nil
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
