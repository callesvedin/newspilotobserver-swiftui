// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newspilotSection = try? newJSONDecoder().decode(NewspilotSection.self, from: jsonData)

import Foundation

// MARK: - NewspilotSection
struct NewspilotSection: Codable, Identifiable {
    let defaultArticleConfigID: Int
    let entityType:String
    let externalID: String?
    let externalSystemID:Int?
    let id:Int
    let invisible: Bool
    let name: String
    let parentID:Int?
    let productID: Int
    let shortName: String?
    let useCaptionProposed: Bool

    enum CodingKeys: String, CodingKey {
        case defaultArticleConfigID = "default_article_config_id"
        case entityType
        case externalID = "external_id"
        case externalSystemID = "external_system_id"
        case id, invisible, name
        case parentID = "parent_id"
        case productID = "product_id"
        case shortName = "short_name"
        case useCaptionProposed = "use_caption_proposed"
    }
}
