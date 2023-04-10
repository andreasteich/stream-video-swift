//
// CallCreatedEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** This event is sent when a call is created. Clients receiving this event should check if the ringing  field is set to true and if so, show the call screen */




internal struct CallCreatedEvent: Codable, JSONEncodable, Hashable, WSCallEvent {

    internal var call: CallResponse
    internal var callCid: String
    internal var createdAt: Date
    /** the members added to this call */
    internal var members: [MemberResponse]
    /** true when the call was created with ring enabled */
    internal var ringing: Bool
    /** The type of event: \"call.created\" in this case */
    internal var type: String

    internal init(call: CallResponse, callCid: String, createdAt: Date, members: [MemberResponse], ringing: Bool, type: String) {
        self.call = call
        self.callCid = callCid
        self.createdAt = createdAt
        self.members = members
        self.ringing = ringing
        self.type = type
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case call
        case callCid = "call_cid"
        case createdAt = "created_at"
        case members
        case ringing
        case type
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(call, forKey: .call)
        try container.encode(callCid, forKey: .callCid)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(members, forKey: .members)
        try container.encode(ringing, forKey: .ringing)
        try container.encode(type, forKey: .type)
    }
}

