// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let product = try? newJSONDecoder().decode(Product.self, from: jsonData)

import Foundation

// MARK: - Product
class Product: Codable {
    let mediaID: Int
    let locale: String
    let organizationID: Int
    let name: String
    let externalSystemID: Int
    let entityType, productDescription: String
    let externalWriterSystemID, id: Int
    let shortName: String
    let iconSmall: JSONNull?

    enum CodingKeys: String, CodingKey {
        case mediaID = "media_id"
        case locale
        case organizationID = "organization_id"
        case name
        case externalSystemID = "external_system_id"
        case entityType
        case productDescription = "description"
        case externalWriterSystemID = "external_writer_system_id"
        case id
        case shortName = "short_name"
        case iconSmall = "icon_small"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
