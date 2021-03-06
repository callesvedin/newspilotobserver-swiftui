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
    var editions:[String]
    var versions:[String]
    var parts:[String]
    let pagesInPublications:[Int:[Page]]
    @State private var selectedPublicationDateIndex:Int=0
    @State private var selectedEditionIndex:Int=0
    @State private var selectedVersionIndex:Int=0
    @State private var selectedPartIndex:Int=0
    
    @Environment(\.presentationMode) var presentationMode
    
    var filter:Binding<PageFilter>    
    
    init(subProduct:SubProduct,pages:[Page], publicationDateQuery:PublicationDateQuery, filter:Binding<PageFilter>) {
        self.subProduct = subProduct
        self.subProductSettings = subProduct.settings
        self.pagesInPublications = Dictionary(grouping: pages, by: \.publicationDateID)
        self.publicationDates = publicationDateQuery.sortedPublicationDates //.filter({(self.pagesInPublications[$0.id])?.count ?? 0 > 0})
        self.parts = subProduct.settings?.parts ?? []
        self.parts.insert("-", at: 0)
        self.editions = subProduct.settings?.editions ?? []
        self.editions.insert("-", at: 0)
        self.versions = subProduct.settings?.versions ?? []
        self.versions.insert("-", at: 0)
        self.filter = filter
        self._selectedPublicationDateIndex = State(initialValue:publicationDates.firstIndex(where: {$0.id == filter.publicationDate.wrappedValue?.id}) ?? 0)
        self._selectedPartIndex = State(initialValue:parts.firstIndex(where: {$0 == filter.part.wrappedValue}) ?? 0)
        self._selectedVersionIndex = State(initialValue:versions.firstIndex(where: {$0 == filter.version.wrappedValue}) ?? 0)
        self._selectedEditionIndex = State(initialValue:editions.firstIndex(where: {$0 == filter.edition.wrappedValue}) ?? 0)
    }
    
    var body: some View {
        NavigationView {
                Form {
                    Section {
                        Picker(selection: $selectedPublicationDateIndex, label: Text("Publication")){
                            ForEach(0 ..< publicationDates.count){n in
                                if ((self.pagesInPublications[self.publicationDates[n].id])?.count ?? 0 > 0) {
                                    HStack {
                                        Text("\(self.publicationDates[n].name)")
                                        Text("(\((self.pagesInPublications[self.publicationDates[n].id])?.count ?? 0) pages)")
                                    }
                                }
                            }
                        }
                    }
                    Section {
                        Picker(selection: $selectedPartIndex, label: Text("Part")){
                            ForEach(0 ..< self.parts.count) { index in
                                Text("\(self.parts[index])").tag(self.parts[index])
                            }
                        }

                        Picker(selection: $selectedEditionIndex, label: Text("Edition")){
                            ForEach(0 ..< self.editions.count) { index in
                                Text("\(self.editions[index])").tag(self.editions[index])
                            }
                        }
                        Picker(selection: $selectedVersionIndex, label: Text("Version")){
                            ForEach(0 ..< self.versions.count) { index in
                                Text("\(self.versions[index])").tag(self.versions[index])
                            }
                        }

                    }
                    HStack(spacing:40) {
                        Spacer()
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                        }, label:{Text("Cancel")})
                        Button(action:{
                            self.filter.wrappedValue.publicationDate = self.publicationDates[self.selectedPublicationDateIndex]
                            self.filter.wrappedValue.part = self.parts[self.selectedPartIndex] == "-" ? nil : self.parts[self.selectedPartIndex]
                            self.filter.wrappedValue.edition = self.editions[self.selectedEditionIndex] == "-" ? nil : self.editions[self.selectedEditionIndex]
                            self.filter.wrappedValue.version = self.versions[self.selectedVersionIndex] == "-" ? nil : self.versions[self.selectedVersionIndex]
                            self.presentationMode.wrappedValue.dismiss()
                        }, label:{Text("Ok")})
                    }
                }
                .navigationBarTitle("Filter")
            }

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
        let publicationDates = publicationDatesData
        let pages = pageData
//        let pageBacks = PageQuery.createBacks(pages: pages)
        return PageFilterView(subProduct: SubProduct(id: 1, productId: 1, name: "Test Sub Product", settingsString: ""),
                              pages: pages,
                              publicationDateQuery: PublicationDateQuery(withProductId: 1, publicationDates: publicationDates),
                              filter: .constant(PageFilter())).border(Color.gray)
    }
}
