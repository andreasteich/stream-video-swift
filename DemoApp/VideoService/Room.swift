//
//  Room.swift
//  StreamVideoSwiftUI
//
//  Created by Martin Mitrevski on 7.7.22.
//

import SwiftUI
import LiveKit
import AVFoundation

class VideoRoom: ObservableObject {
        
    private let room: Room
    
    static func create(with room: Room) -> VideoRoom {
        return VideoRoom(room: room)
    }
    
    private init(room: Room) {
        self.room = room
    }
    
    func addDelegate(_ delegate: VideoRoomDelegate) {
        self.room.add(delegate: delegate)
    }
    
    internal var remoteParticipants: [Sid : RemoteParticipant] {
        self.room.remoteParticipants
    }
    
    internal var localParticipant: LocalParticipant? {
        self.room.localParticipant
    }
    
    internal var connectionStatus: ConnectionStatus {
        self.room.connectionState.mapped
    }
}

typealias VideoRoomDelegate = RoomDelegate

struct VideoOptions {
    //TODO:
}
