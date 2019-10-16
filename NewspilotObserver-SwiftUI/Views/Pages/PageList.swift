//
//  PageList.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-04.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot

struct PageList: View {
    private var publicationDates:[PublicationDate]
    private var subProduct:SubProduct
    @ObservedObject var pageQuery:PageQuery
    @State private var name:String = "None"
    @State private var selectedIndex:Int = 0
        

    init(newspilot:Newspilot, subProduct:SubProduct, publicationDates:[PublicationDate]) {
        self.subProduct = subProduct
        self.publicationDates = publicationDates
        self.pageQuery = PageQuery(withNewspilot: newspilot, productId: subProduct.productID, subProductId: subProduct.id, publicationDateId: -1)
    }
    
    
    var body: some View {
        VStack {
            Form {
                Picker(selection: $selectedIndex, label: Text("Publication")){
                    ForEach(0..<self.publicationDates.count) { index in
                        Text("\(self.publicationDates[index].name ?? "-")").tag(index)
                    }
                }
                List {
                    Text("Here comes the pages of \(publicationDates[selectedIndex].name ?? "-")")
                    ForEach (self.pageQuery.pages) {page in
                        Text("\(page.name)")
                    }
                }
            }
       
        }
        .navigationBarTitle(self.subProduct.name).onAppear{
            if (self.selectedIndex > 0) {
                self.pageQuery.publicationDateId = self.publicationDates[self.selectedIndex].id
                self.pageQuery.load()
            }
        }
    
    }
}

struct PageList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PageList(newspilot:Newspilot(server: "", login: "", password: ""), subProduct: SubProduct(id: 1, productId: 11, name: "My Sub Product2"),
                     publicationDates: [
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-10"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "2", name: "Pub 2", productID: 1, pubDate: "2019-10-11"),
                        PublicationDate(entityType: "PublicationDate", id: 1, issuenumber: "1", name: "Pub 1", productID: 1, pubDate: "2019-10-12")
            ])
        }
    }
}
