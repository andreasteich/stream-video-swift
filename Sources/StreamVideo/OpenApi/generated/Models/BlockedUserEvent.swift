//
// BlockedUserEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** This event is sent to call participants to notify when a user is blocked on a call, clients can use this event to show a notification.  If the user is the current user, the client should leave the call screen as well */




internal struct BlockedUserEvent: Codable, JSONEncodable, Hashable, WSCallEvent {

    internal var blockedByUser: UserResponse?
    internal var callCid: String
    internal var createdAt: Date
    /** The type of event: \"call.blocked_user\" in this case */
    internal var type: String
    internal var user: UserResponse

    internal init(blockedByUser: UserResponse? = nil, callCid: String, createdAt: Date, type: String, user: UserResponse) {
        self.blockedByUser = blockedByUser
        self.callCid = callCid
        self.createdAt = createdAt
        self.type = type
        self.user = user
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedByUser = "blocked_by_user"
        case callCid = "call_cid"
        case createdAt = "created_at"
        case type
        case user
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(blockedByUser, forKey: .blockedByUser)
        try container.encode(callCid, forKey: .callCid)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

