//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import NukeUI
import StreamVideo
import SwiftUI

public struct IncomingCallView: View {
    
    @Injected(\.streamVideo) var streamVideo
    @Injected(\.fonts) var fonts
    @Injected(\.colors) var colors
    @Injected(\.images) var images
    @Injected(\.utils) var utils
    
    @StateObject var viewModel: IncomingViewModel
            
    var onCallAccepted: (String) -> Void
    var onCallRejected: (String) -> Void
    
    public init(
        callInfo: IncomingCall,
        onCallAccepted: @escaping (String) -> Void,
        onCallRejected: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: IncomingViewModel(callInfo: callInfo)
        )
        self.onCallAccepted = onCallAccepted
        self.onCallRejected = onCallRejected
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            if viewModel.callParticipants.count > 1 {
                CallingGroupView(
                    participants: viewModel.callParticipants.map { $0.toUser() }
                )
            } else {
                AnimatingParticipantView(
                    participant: viewModel.callParticipants.first?.toUser(),
                    caller: viewModel.callInfo.callerId
                )
            }
            
            CallingParticipantsView(
                participants: viewModel.callParticipants.map { $0.toUser() },
                caller: viewModel.callInfo.callerId
            )
            .padding()
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(L10n.Call.Incoming.title)
                    .applyCallingStyle()
                CallingIndicator()
            }

            Spacer()
                        
            HStack {
                Spacing()
                
                Button {
                    onCallRejected(viewModel.callInfo.id)
                } label: {
                    images.hangup
                        .applyCallButtonStyle(
                            color: Color.red,
                            backgroundType: .circle,
                            size: 80
                        )
                }
                .padding(.all, 8)
                
                Spacing(size: 3)

                Button {
                    onCallAccepted(viewModel.callInfo.id)
                } label: {
                    images.acceptCall
                        .applyCallButtonStyle(
                            color: Color.green,
                            backgroundType: .circle,
                            size: 80
                        )
                }
                .padding(.all, 8)
                
                Spacing()
            }
            .padding()
        }
        .background(
            images.incomingCallBackground
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            if streamVideo.videoConfig.playSounds {
                utils.callSoundsPlayer.playIncomingCallSound()
            }
        }
        .onDisappear {
            utils.callSoundsPlayer.stopOngoingSound()
        }
    }
}
