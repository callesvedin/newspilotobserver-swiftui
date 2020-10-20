//
//  SetStatusView.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2020-10-12.
//  Copyright © 2020 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI

struct SetStatusView: View {
    let page:Page
    var statuses:[Status]
    @Binding var isShown:Bool
    @State var selectedStatusIndex = 0


    init(page:Page, statuses:[Status], isShown:Binding<Bool>){
        self.page = page
        self.statuses = statuses
        self._isShown = isShown
        self.selectedStatusIndex = statuses.firstIndex(where: {status in status.id == page.status}) ?? 0
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.2)

            VStack {
                Picker("Select Status", selection: self.$selectedStatusIndex){
                    ForEach(0 ..< statuses.count) {statusIndex in
                        HStack {
                            if statuses[statusIndex].statusColor == .white {
                                Image.init(systemName: "circle").foregroundColor(Color(.black))
                            }else {
                                Image.init(systemName: "circle.fill").foregroundColor(Color(statuses[statusIndex].statusColor))
                            }

                            Text("\(statuses[statusIndex].name)")
                        }
                    }
                }
                
                Button("Ok",action:  {
                    if (selectedStatusIndex >= 0) {
                        NewspilotManager.setPageStatus(self.statuses[selectedStatusIndex].id, forPageId: page.id)
                    }
                    isShown.toggle()
                }).padding()
                
            }
            .background(Color(.systemBackground))
            .cornerRadius(25)
            .frame(width:300)
            
        }
        .ignoresSafeArea()
//        .animation(.default, value: isShown)
    }
    
}

struct SetStatusView_Previews: PreviewProvider {
    
    static var previews: some View {
        return
            Group {
                ZStack {
                    Color(.systemBackground)
                    SetStatusView(
                        page:pageData2[2],
                        statuses: statusData,
                        isShown: .constant(true)
                    )
                    
                }.environment(\.colorScheme, .light)
                
                ZStack {
                    Color(.systemBackground)
                    SetStatusView(
                        page:pageData2[2],
                        statuses: statusData,
                        isShown: .constant(true)
                    )
                }.environment(\.colorScheme, .dark)
            }
    }
}

