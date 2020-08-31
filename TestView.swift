//
//  TestView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-08-28.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct TestView: View {
        @State private var currentPage = 0

        var body: some View {
            PagerView(pageCount: 15, currentIndex: $currentPage) {
                ForEach (0..<15, id: \.self) {index in
                    Text("\(index)").frame(width: 300).background(Color.red)
                }                
            }
//            PagerView(pageCount: 3, currentIndex: $currentPage) {
//                Color.blue
//                Color.red
//                Color.green
//            }
        }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
