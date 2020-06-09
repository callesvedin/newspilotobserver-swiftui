//
//  BannerModifier.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2020-01-02.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct ConnectionModifier: ViewModifier {
    @EnvironmentObject var loginHandler:LoginHandler
    
    func body(content: Content) -> some View {
        let title = self.loginHandler.connectionStatus == .notConnected ? "Connection lost":"Connecting..."
        let message = self.loginHandler.connectionStatus == .notConnected ? "Connection lost to \(loginHandler.newspilot.server ?? "-")":"Connecting to \(loginHandler.newspilot.server ?? "-")"
        return ZStack() {
            content
            if self.loginHandler.connectionStatus == .notConnected || self.loginHandler.connectionStatus == .connecting {
                VStack{
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(title)
                                .bold()
                            Text(message)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color(UIColor.label))
                    .padding(8)
                    .background(Color(UIColor.systemRed))
                    .cornerRadius(8)
                }
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

//struct BannerModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerModifier(data:BannerModifier.BannerData(title:"Hello", detail: "Details comming here",type:.Info))
//    }
//}
