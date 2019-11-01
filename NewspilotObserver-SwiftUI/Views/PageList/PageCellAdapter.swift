//
//  PageCellAdapter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import UIKit

class PageCellAdapter {
    
    let newspilotServer:String
    var statuses:[Status]    
    var sections:[NewspilotSection]
    
    init(newspilotServer:String, statuses:[Status], sections:[NewspilotSection]){
        self.statuses = statuses
        self.newspilotServer = newspilotServer
        self.sections = sections
    }
    
    func getPageViewModel(from page:Page) -> PageViewModel {
        
        var statusColor:UIColor
        if let status = statuses.first(where: {status in status.id == page.status}) {
            statusColor = intToColor(value: Int(status.color))
        }else{
            statusColor = UIColor.white
        }
        var sectionName:String
        if let section = sections.first(where: {section in section.id == page.sectionID}) {
            sectionName = section.name
        }else{
            sectionName = "-"
        }
        
        let thumbUrl = URL(string: "https://\(newspilotServer):8443/newspilot/thumb?id=\(Int(page.id))&type=5")
        let previewUrl = URL(string: "https://\(newspilotServer):8443/newspilot/preview?id=\(Int(page.id))&type=5")
        return PageViewModel(id:page.id, name: page.name, section:sectionName, statusColor: statusColor, thumbUrl: thumbUrl, previewUrl: previewUrl )
    }
    
    private func intToColor(value: Int) -> UIColor {
        let value = value | 255 << 24
        return UIColor(
            red: CGFloat(CGFloat((value & 255 << 16) >> 16) / 255.0),
            green: CGFloat(CGFloat((value & 255 << 8) >> 8) / 255.0),
            blue: CGFloat(CGFloat((value & 255 << 0) >> 0) / 255.0),
            alpha: 1.0
        )
    }
}
