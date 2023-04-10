//
// SendReactionResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif





internal struct SendReactionResponse: Codable, JSONEncodable, Hashable {

    /** Duration of the request in human-readable format */
    internal var duration: String
    internal var reaction: ReactionResponse

    internal init(duration: String, reaction: ReactionResponse) {
        self.duration = duration
        self.reaction = reaction
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case reaction
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(reaction, forKey: .reaction)
    }
}

