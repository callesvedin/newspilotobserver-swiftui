// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let entityFlag = try? newJSONDecoder().decode(EntityFlag.self, from: jsonData)

import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

// MARK: - EntityFlag
struct EntityFlag: Identifiable, Codable {
    let entityType: String
    let fillSpace, locked:Bool
    let id: Int
    let name:String
    let offSymbol, onSymbol: String?
    let sortKey: Int
    let type: String
    let userEditable: Bool

    var offImage, onImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case entityType
        case fillSpace = "fill_space"
        case id, locked, name
        case offSymbol = "off_symbol"
        case onSymbol = "on_symbol"
        case sortKey = "sort_key"
        case type
        case userEditable = "user_editable"
    }
   
//    #if os(macOS)
//    mutating func setOffImage(_ image:NSImage) {
//        offImage = image
//    }
//
//    mutating func setOnImage(_ image:NSImage?) {
//        onImage = image
//    }
//
//    #else
    mutating func setOffImage(_ image:UIImage) {
        offImage = image
    }
        
    mutating func setOnImage(_ image:UIImage?) {
        onImage = image
    }
//    #endif

}


