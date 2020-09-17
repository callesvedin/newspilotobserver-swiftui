//
//  BannerModifier.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-01-02.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

enum BannerType {
    case Info
    case Warning
    case Success
    case Error
    
    var tintColor: Color {
        switch self {
        case .Info:
            return Color(red: 67/255, green: 154/255, blue: 215/255)
        case .Success:
            return Color.green
        case .Warning:
            return Color.yellow
        case .Error:
            return Color.red
        }
    }
}


struct BannerModifier: ViewModifier {
    
    struct BannerData {
        var title:String
        var detail:String
        var type: BannerType
    }
    
    
    var data:BannerData
    @Binding var show:Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomLeading) {
            content
            if show {
                VStack{
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 22)
                    .padding(.top, 12)
                    .padding(.bottom, 14)
                    .background(data.type.tintColor)
                    .cornerRadius(8)
                }
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }
                Spacer()
                //                .onAppear(perform: {
                //                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                //                        withAnimation {
                //                            self.show = false
                //                        }
                //                    }
                //                })
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct BannerModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("ContentView").frame(minWidth: 300, idealWidth: nil, maxWidth: .infinity, minHeight: 600, idealHeight: nil, maxHeight: .infinity)
                .modifier(BannerModifier(data:BannerModifier.BannerData(title:"Hello", detail: "Details comming here",type:.Info), show:Binding.constant(true))
            )
            Text("ContentView").frame(minWidth: 300, idealWidth: nil, maxWidth: .infinity, minHeight: 600, idealHeight: nil, maxHeight: .infinity)
                .modifier(BannerModifier(data:BannerModifier.BannerData(title:"Hello", detail: "Details comming here",type:.Warning), show:Binding.constant(true))
            )
            Text("ContentView").frame(minWidth: 300, idealWidth: nil, maxWidth: .infinity, minHeight: 600, idealHeight: nil, maxHeight: .infinity)
                .modifier(BannerModifier(data:BannerModifier.BannerData(title:"Hello", detail: "Details comming here",type:.Error), show:Binding.constant(true))
            )
        }
    }
}
