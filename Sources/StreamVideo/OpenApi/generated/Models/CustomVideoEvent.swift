//
// CustomVideoEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** A custom event, this event is used to send custom events to other participants in the call. */




internal struct CustomVideoEvent: Codable, JSONEncodable, Hashable, WSCallEvent {

    internal var callCid: String
    internal var createdAt: Date
    /** Custom data for this object */
    internal var custom: [String: AnyCodable]
    /** The type of event, \"custom\" in this case */
    internal var type: String
    internal var user: UserResponse

    internal init(callCid: String, createdAt: Date, custom: [String: AnyCodable], type: String, user: UserResponse) {
        self.callCid = callCid
        self.createdAt = createdAt
        self.custom = custom
        self.type = type
        self.user = user
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case callCid = "call_cid"
        case createdAt = "created_at"
        case custom
        case type
        case user
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(callCid, forKey: .callCid)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

