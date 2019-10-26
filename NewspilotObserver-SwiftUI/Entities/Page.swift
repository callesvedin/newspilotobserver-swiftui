// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let page = try? newJSONDecoder().decode(Page.self, from: jsonData)

import Foundation

// MARK: - Page
struct Page: Codable, Identifiable {
    let entityType: String
    let archiveID: Int?
    let arkitexData: String?
    let bleed, bookedSectionID: Int?
    let bookedTemplate: String?
    let bottomMargin: Int?
    let color: String?
    let columnCount, columnWidth: Int?
    let controlFile: String?
    let createdDate: String?
    let createdUserID: Int?
    let custom1, custom2, custom3, custom4: String?
    let custom5, deadline, descriptiveName: String?
    let dirty: Int?
    let documentMacro, documentName: String?
    let documentType, edType, editable: Int?
    let edition: String?
    let entitylockID, externalSystemID: Int?
    let fileExists: Bool?
    let firstPagin: Int
    let flags: [Int]?
    let guid: String?
    let gutterWidth, innerMargin: Int?
    let id: Int
    let joinWithPrev: Bool?
    let label, masterID: Int?
    let masterName: String?
    let isMasterPage: Bool?
    let masterSpread, message: String?
    let multiPageCount, multiPagePos: Int?
    let name:String
    let nameMacro, note: String?
    let outerMargin, pageNumber: Int?
    let part: String?
    let physicalHeight, physicalWidth: Int?
    let plate: String?
    let preproductionType, previewCRC, previewCreator: Int?
    let printDateBW, printDateCmyk, printMacroBW, printMacroCmyk: String?
    let printVersionBW, printVersionCmyk, printableBW, printableCmyk: Int?
    let productID, publicationDateID: Int?
    let reference: String?
    let respUserID: Int?
    let restoredDate: String?
    let sectionID: Int?
    let sectionOverride: Bool?
    let sequence: String?
    let status, subProductID: Int
    let systemLinkIDS: [Int]?
    let tags, template: String?
    let templateOverride: Bool?
    let thumbCRC, topMargin, uniqueID: Int?
    let unlockedToken: String?
    let updatedDate: String?
    let updatedUserID: Int?
    let version: String?
    
    enum CodingKeys: String, CodingKey {
        case entityType
        case archiveID = "archive_id"
        case arkitexData = "arkitex_data"
        case bleed
        case bookedSectionID = "booked_section_id"
        case bookedTemplate = "booked_template"
        case bottomMargin = "bottom_margin"
        case color
        case columnCount = "column_count"
        case columnWidth = "column_width"
        case controlFile = "control_file"
        case createdDate = "created_date"
        case createdUserID = "created_user_id"
        case custom1, custom2, custom3, custom4, custom5, deadline
        case descriptiveName = "descriptive_name"
        case dirty
        case documentMacro = "document_macro"
        case documentName = "document_name"
        case documentType = "document_type"
        case edType = "ed_type"
        case editable, edition
        case entitylockID = "entitylock_id"
        case externalSystemID = "external_system_id"
        case fileExists = "file_exists"
        case firstPagin = "first_pagin"
        case flags, guid
        case gutterWidth = "gutter_width"
        case id
        case innerMargin = "inner_margin"
        case joinWithPrev = "join_with_prev"
        case label
        case masterID = "master_id"
        case masterName = "master_name"
        case isMasterPage = "is_master_page"
        case masterSpread = "master_spread"
        case message
        case multiPageCount = "multi_page_count"
        case multiPagePos = "multi_page_pos"
        case name
        case nameMacro = "name_macro"
        case note
        case outerMargin = "outer_margin"
        case pageNumber = "page_number"
        case part
        case physicalHeight = "physical_height"
        case physicalWidth = "physical_width"
        case plate
        case preproductionType = "preproduction_type"
        case previewCRC = "preview_crc"
        case previewCreator = "preview_creator"
        case printDateBW = "print_date_bw"
        case printDateCmyk = "print_date_cmyk"
        case printMacroBW = "print_macro_bw"
        case printMacroCmyk = "print_macro_cmyk"
        case printVersionBW = "print_version_bw"
        case printVersionCmyk = "print_version_cmyk"
        case printableBW = "printable_bw"
        case printableCmyk = "printable_cmyk"
        case productID = "product_id"
        case publicationDateID = "publication_date_id"
        case reference
        case respUserID = "resp_user_id"
        case restoredDate = "restored_date"
        case sectionID = "section_id"
        case sectionOverride = "section_override"
        case sequence, status
        case subProductID = "sub_product_id"
        case systemLinkIDS = "system_link_ids"
        case tags, template
        case templateOverride = "template_override"
        case thumbCRC = "thumb_crc"
        case topMargin = "top_margin"
        case uniqueID = "unique_id"
        case unlockedToken = "unlocked_token"
        case updatedDate = "updated_date"
        case updatedUserID = "updated_user_id"
        case version
    }
}

extension Page {
    var backKey:BackKey {
        get{
            return BackKey(part: self.part, version: self.version, edition: self.edition)
        }
    }
}

