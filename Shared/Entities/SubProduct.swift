// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let subProduct = try? newJSONDecoder().decode(SubProduct.self, from: jsonData)

import Foundation

// MARK: - SubProduct
class SubProduct: Codable, Identifiable, Hashable {
    
    static func == (lhs: SubProduct, rhs: SubProduct) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(entityType)
        hasher.combine(id)
    }
    
    var useCaptionProposed:Int?
    let productID: Int
    let name: String
    var externalID: String?
    var defaultArticleConfigID:Int?
    let id: Int
    let entityType: String
    var parentID:Int?
    var externalSystemID: Int?
    var shortName: String?
    var invisible: Int?
    let settingsString:String
    lazy var settings:SubProductSettings? = SubProductSettings(xml:settingsString)

    init(id:Int, productId:Int, name:String, settingsString: String) {
        self.id = id
        self.productID = productId
        self.name = name        
        self.entityType = "SubProduct"
        self.settingsString = settingsString
    }
    
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
        case settingsString = "settings"
    }
}
