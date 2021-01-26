//
//  SearchBar.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-08-26.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
       //@State private var showCancelButton: Bool = false
       var onCommit: () ->Void = {        
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
       
       var body: some View {
           HStack {
               HStack {
                   Image(systemName: "magnifyingglass")
                   
                   // Search text field
                   ZStack (alignment: .leading) {
                       if searchText.isEmpty { // Separate text for placeholder to give it the proper color
                           Text("Search")
                       }
                       TextField("", text: $searchText, onEditingChanged: { isEditing in

                       }, onCommit: onCommit).foregroundColor(.primary)
                   }
                   
                   Button(action: {
                       self.searchText = ""
                   }) {
                       Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                   }
               }
               .font(Font.bodyFont)
               .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
               .foregroundColor(.secondary) // For magnifying glass and placeholder text
               .background(Color(.tertiarySystemFill))
               .cornerRadius(10.0)
     
           }
           .padding(.horizontal)
       }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            SearchBar(searchText: .constant("News"))
        }
    }
}


