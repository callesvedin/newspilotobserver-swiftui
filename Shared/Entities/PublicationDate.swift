// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let publicationDate = try? newJSONDecoder().decode(PublicationDate.self, from: jsonData)

import Foundation

// MARK: - PublicationDate
class PublicationDate: Codable, Hashable, Identifiable {
    
    static func == (lhs: PublicationDate, rhs: PublicationDate) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let entityType: String
    let id: Int
    let issuenumber:String?
    let name: String
    let productID: Int
    let pubDate: String

    enum CodingKeys: String, CodingKey {
        case entityType, id, issuenumber, name
        case productID = "product_id"
        case pubDate = "pub_date"
    }

    init(entityType: String, id: Int, issuenumber: String?, name: String, productID: Int, pubDate: String) {
        self.entityType = entityType
        self.id = id
        self.issuenumber = issuenumber
        self.name = name
        self.productID = productID
        self.pubDate = pubDate
    }
}

extension PublicationDate {
    func inDateInterval(from fromDate:Date, to toDate:Date) -> Bool {
        let date:Date = createDateFromString(self.pubDate)
        return date >= fromDate && date <= toDate
    }

    private func createDateFromString(_ string:String) -> Date {
        //    "2020-10-14T00:00+02:00"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        return dateFormatter.date(from:string)!
    }
}

