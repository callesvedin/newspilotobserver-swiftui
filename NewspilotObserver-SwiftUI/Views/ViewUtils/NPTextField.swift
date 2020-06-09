//
//  NPTextField.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-06-05.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct NPTextField: View {
    let placeHolder:String
    let text:Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeHolder)
                .foregroundColor(Color(.placeholderText))
                .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            TextField("", text: text)
        }
//        .padding(.top, 15)
        .animation(.default)
    }
}

struct NPTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        let labels = ["First Name", "Last Name", "Street", "City", "Post Code"]
        
        return
            List(0..<5) { index in
                NPTextField(placeHolder: labels[index], text: .constant("fasd"))
            }.listStyle(GroupedListStyle())
    }
}
