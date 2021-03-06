/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation


let publicationDatesData: [PublicationDate] = load("publicationDates.json")
let organizationData: [Organization] = load("organizations.json")
let productsData: [Product] = load("products.json")
let subProductsData: [SubProduct] = load("subproducts.json")
let sectionsData: [NewspilotSection] = load("sections.json")
let pageData: [Page] = load("PAV1E1.json")
let pageData2: [Page] = load("PAV1E2.json")
let pageData3: [Page] = load("PAV1E3.json")

let statusData: [Status] = load("statuses.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

