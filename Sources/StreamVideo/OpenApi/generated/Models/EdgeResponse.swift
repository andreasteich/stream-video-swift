//
// EdgeResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif





internal struct EdgeResponse: Codable, JSONEncodable, Hashable {

    internal var continentCode: String
    internal var countryIsoCode: String
    internal var green: Int
    internal var id: String
    internal var latencyTestUrl: String
    internal var latitude: Float
    internal var longitude: Float
    internal var red: Int
    internal var subdivisionIsoCode: String
    internal var yellow: Int

    internal init(continentCode: String, countryIsoCode: String, green: Int, id: String, latencyTestUrl: String, latitude: Float, longitude: Float, red: Int, subdivisionIsoCode: String, yellow: Int) {
        self.continentCode = continentCode
        self.countryIsoCode = countryIsoCode
        self.green = green
        self.id = id
        self.latencyTestUrl = latencyTestUrl
        self.latitude = latitude
        self.longitude = longitude
        self.red = red
        self.subdivisionIsoCode = subdivisionIsoCode
        self.yellow = yellow
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case continentCode = "continent_code"
        case countryIsoCode = "country_iso_code"
        case green
        case id
        case latencyTestUrl = "latency_test_url"
        case latitude
        case longitude
        case red
        case subdivisionIsoCode = "subdivision_iso_code"
        case yellow
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(continentCode, forKey: .continentCode)
        try container.encode(countryIsoCode, forKey: .countryIsoCode)
        try container.encode(green, forKey: .green)
        try container.encode(id, forKey: .id)
        try container.encode(latencyTestUrl, forKey: .latencyTestUrl)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(red, forKey: .red)
        try container.encode(subdivisionIsoCode, forKey: .subdivisionIsoCode)
        try container.encode(yellow, forKey: .yellow)
    }
}

