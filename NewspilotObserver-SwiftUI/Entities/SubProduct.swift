// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let subProduct = try? newJSONDecoder().decode(SubProduct.self, from: jsonData)

import Foundation

// MARK: - SubProduct
class SubProduct: Codable {
    let useCaptionProposed:Int?
    let productID: Int
    let name: String
    let externalID: String?
    let defaultArticleConfigID:Int?
    let id: Int
    let entityType: String
    let parentID:Int?
    let externalSystemID: Int?
    let shortName: String
    let invisible: Int?

    enum CodingKeys: String, CodingKey {
        case useCaptionProposed = "use_caption_proposed"
        case productID = "product_id"
        case name
        case externalID = "external_id"
        case defaultArticleConfigID = "default_article_config_id"
        case id, entityType
        case parentID = "parent_id"
        case externalSystemID = "external_system_id"
        case shortName = "short_name"
        case invisible
    }
}
