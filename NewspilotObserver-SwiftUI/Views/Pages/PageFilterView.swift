//
//  PageFilterView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-21.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
enum EditedValue {
    case publicationDate
    case none
}

struct PageFilterView: View {
    let subProduct:SubProduct
    let publicationDates:[PublicationDate]
    @State var editedValue:EditedValue = .none
    
    @ObservedObject var filter:PageFilter
    
    init(subProduct:SubProduct, publicationDates:[PublicationDate], filter:PageFilter) {
        self.subProduct = subProduct
        self.publicationDates = publicationDates
        self.filter = filter
    }
    
    var body: some View {
        VStack {
            Text("Filter")
            .font(.title)
        Form {
            
            HStack {
                Text("Publication date:")
                Spacer()
                Button("\(getPublicationDateName())"){
                    self.editedValue = .publicationDate
                    print("Publicationdate")
                }
            }.padding()
            if self.editedValue == .publicationDate {
                Picker(selection: $filter.publicationDateId, label: Text("Publication")){
                    ForEach(self.publicationDates) { publicationDate in
                        Text("\(publicationDate.name)").tag(publicationDate.id)
                    }
                }.labelsHidden().pickerStyle(WheelPickerStyle())
            }
            
            HStack {
                Text("Edition")
                Spacer()
                Button("TEST") {
                    self.editedValue = .none
                    print("None")
                }
                
            }.padding()
            }}
    }
    
    func getPublicationDateName() -> String {
        guard let publicationDate = publicationDates.first(where: {publication in publication.id == filter.publicationDateId}) else {
            return "-"
        }
        return publicationDate.name
    }
}

struct PageFilterView_Previews: PreviewProvider {
    static var previews: some View {
        PageFilterView(subProduct: SubProduct(id: 1, productId: 1, name: "Test Sub Product"),
                       publicationDates: [
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20")],
                       filter: PageFilter())
    }
}
