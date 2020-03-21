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
    @State private var selectedPublicationDateId:Int = 0
    var selectedPublicationDate:PublicationDate? {
        get {
            publicationDates.first(where: {date in date.id == selectedPublicationDateId})
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var filter:Binding<PageFilter>    
    
    init(subProduct:SubProduct, publicationDateQuery:PublicationDateQuery, filter:Binding<PageFilter>) {
        self.subProduct = subProduct
        self.subProductSettings = subProduct.settings
        self.publicationDates = publicationDateQuery.sortedPublicationDates
        self.editions = subProduct.settings?.editions ?? []
        self.filter = filter
        self.selectedPublicationDateId = filter.publicationDate.wrappedValue?.id ?? 0
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selectedPublicationDateId, label: Text("Publication")){
                    ForEach(self.publicationDates) { publicationDate in
                        Text("\(publicationDate.name)").tag(publicationDate.id)
                    }
            }.labelsHidden()
            HStack(spacing:40) {
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }, label:{Text("Cancel")})
                Button(action:{                    
                    self.filter.wrappedValue.publicationDate = self.selectedPublicationDate
                    self.presentationMode.wrappedValue.dismiss()
                }, label:{Text("Ok")})
            }
        }
        .onAppear(){
            self.selectedPublicationDateId = self.filter.publicationDate.wrappedValue?.id ?? 0
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
                       publicationDateQuery: PublicationDateQuery(withNewspilot: nil, productId: 1),
                       filter: .constant(PageFilter())).border(Color.gray)
    }
}
