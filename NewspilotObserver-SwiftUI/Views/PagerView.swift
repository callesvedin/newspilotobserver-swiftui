//
//  PagerView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-08-27.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct PagerView<Content:View>: View {
    let pageCount:Int
    @Binding var currentIndex:Int
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    init(pageCount:Int, currentIndex:Binding<Int>, @ViewBuilder content:()-> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
    
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        
        PagerView(pageCount:3, currentIndex:.constant(1)) {
            ForEach (0..<15, id: \.self) {index in
                Text("\(index)").frame(width: 300).background(Color.red)
            }
        }
    }
}
