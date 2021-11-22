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
    @State var selectedStatusIndex:Int


    init(page:Page, statuses:[Status], isShown:Binding<Bool>){
        self.page = page
        self.statuses = statuses
        self._isShown = isShown
        let index = statuses.firstIndex(where: {status in status.id == page.status}) ?? 0
        _selectedStatusIndex = State(initialValue: index as Int)
    }
    
    var body: some View {
            VStack {
                Picker("Select Status", selection: self.$selectedStatusIndex){
                    ForEach(0 ..< statuses.count) {statusIndex in
                        HStack {
                            if statuses[statusIndex].statusColor == UIColor.white {
                                Image.init(systemName: "circle").foregroundColor(Color(UIColor.black))
                            }else {
                                Image.init(systemName: "circle.fill").foregroundColor(Color(statuses[statusIndex].statusColor))
                            }

                            Text("\(statuses[statusIndex].name)")
                        }
                    }
                }
                
                HStack {
                    Button("Cancel",action:  {
                        isShown.toggle()
                    }).font(Font.buttonFont).foregroundColor(.red).padding()
                    
                    Button("Ok",action:  {
                        if (selectedStatusIndex >= 0) {
                            NewspilotManager.setPageStatus(self.statuses[selectedStatusIndex].id, forPageId: page.id)
                        }
                        isShown.toggle()
                    }).font(Font.buttonFont).padding()

                }
            }.font(Font.bodyFont)
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

