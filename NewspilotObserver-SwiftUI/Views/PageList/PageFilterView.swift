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
    let subProductSettings:SubProductSettings?
    let editions:[String]
    @State private var selectedPublicationDate:Int = 0
//    @Binding var filter:PageFilter
    @Environment(\.presentationMode) var presentationMode
    
    var filter:Binding<PageFilter>
    
    init(subProduct:SubProduct, publicationDates:[PublicationDate], filter:Binding<PageFilter>) {
        self.subProduct = subProduct
        self.subProductSettings = subProduct.settings
        self.publicationDates = publicationDates
        self.editions = subProduct.settings?.editions ?? []
        self.filter = filter
        self.selectedPublicationDate = filter.publicationDateId.wrappedValue
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedPublicationDate, label: Text("Publication")){
                    ForEach(self.publicationDates) { publicationDate in
                        Text("\(publicationDate.name)").tag(publicationDate.id)
                    }
            }.labelsHidden()
            HStack {
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }, label:{Text("Cancel")})
                Button(action:{                    
                    self.filter.wrappedValue.publicationDateId = self.$selectedPublicationDate.wrappedValue
                    self.presentationMode.wrappedValue.dismiss()
//                    self.filter.publicationDateId = 1//$selectedPublicationDate.wrappedValue
                }, label:{Text("Ok")})
            }.padding()
        }.onAppear(){
            self.selectedPublicationDate = self.filter.publicationDateId.wrappedValue
        }
//            Picker(selection: $selectedEditionIndex, label: Text("Edition")){
//                ForEach(0 ..< self.editions.count) { index in
//                    Text("\(self.editions[index])").tag(self.editions[index])
//                }
//            }
//
//            Picker(selection: $filter.edition, label: Text("Edition 2")){
//                ForEach(subProduct.settings!.editions, id: \.self) { edition in
//                    Text("\(edition)")
//                }
//            }
                    
    }
}

struct PageFilterView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        return PageFilterView(subProduct: SubProduct(id: 1, productId: 1, name: "Test Sub Product", settingsString: ""),
                       publicationDates: [
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "", name: "Pub 1", productID: 1, pubDate: "2019-10-20")],
                       filter: .constant(PageFilter()))
    }
}
