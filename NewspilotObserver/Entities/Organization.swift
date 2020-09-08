// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let organization = try? newJSONDecoder().decode(Organization.self, from: jsonData)

import Foundation

// MARK: - Organization
class Organization: Codable, Identifiable {
    let entityType: String
    let defaultPrivilegeGroupID: Int
    let organizationDescription: String
    let id: Int
    let macBylinePath, name: String
    let organizationalGroupID: Int
    let pcBylinePath, shortName: String

    var products:[Product] = [] // Custom property
    
    enum CodingKeys: String, CodingKey {
        case entityType
        case defaultPrivilegeGroupID = "default_privilege_group_id"
        case organizationDescription = "description"
        case id
        case macBylinePath = "mac_byline_path"
        case name
        case organizationalGroupID = "organizational_group_id"
        case pcBylinePath = "pc_byline_path"
        case shortName = "short_name"
    }
}
