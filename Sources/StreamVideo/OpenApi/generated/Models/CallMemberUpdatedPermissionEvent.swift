//
// CallMemberUpdatedPermissionEvent.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** This event is sent when one or more members get its role updated */




internal struct CallMemberUpdatedPermissionEvent: Codable, JSONEncodable, Hashable, WSCallEvent {

    internal var call: CallResponse
    internal var callCid: String
    /** The capabilities by role for this call */
    internal var capabilitiesByRole: [String: [String]]
    internal var createdAt: Date
    /** The list of members that were updated */
    internal var members: [MemberResponse]
    /** The type of event: \"call.member_added\" in this case */
    internal var type: String

    internal init(call: CallResponse, callCid: String, capabilitiesByRole: [String: [String]], createdAt: Date, members: [MemberResponse], type: String) {
        self.call = call
        self.callCid = callCid
        self.capabilitiesByRole = capabilitiesByRole
        self.createdAt = createdAt
        self.members = members
        self.type = type
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case call
        case callCid = "call_cid"
        case capabilitiesByRole = "capabilities_by_role"
        case createdAt = "created_at"
        case members
        case type
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(call, forKey: .call)
        try container.encode(callCid, forKey: .callCid)
        try container.encode(capabilitiesByRole, forKey: .capabilitiesByRole)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(members, forKey: .members)
        try container.encode(type, forKey: .type)
    }
}

