//
//  PageCellAdapter.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-10-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import UIKit

class PageModelAdapter {
    
    let newspilotServer:String
    var statuses:[Status]
    var sections:[NewspilotSection]
    var flags:[EntityFlag]
    
    
    init(newspilotServer:String, statuses:[Status], sections:[NewspilotSection], flags:[EntityFlag]){
        self.statuses = statuses
        self.newspilotServer = newspilotServer
        self.sections = sections
        self.flags = flags.sorted(by: {f1,f2 in f1.sortKey < f2.sortKey})
    }
    
    func getPageViewModel(from page:Page) -> PageViewModel {
        
        var statusColor:UIColor
        var statusName:String
        if let status = statuses.first(where: {status in status.id == page.status}) {
            statusColor = UIColor.intToColor(value: Int(status.color))
            statusName = status.name
        }else{
            statusColor = UIColor.white
            statusName = ""
        }
        let sectionName:String? = sections.first(where: {section in section.id == page.sectionID})?.name
        let template = page.template
        let thumbUrl = URL(string: "https://\(newspilotServer):8443/newspilot/thumb?id=\(Int(page.id))&type=5")
        let previewUrl = URL(string: "https://\(newspilotServer):8443/newspilot/preview?id=\(Int(page.id))&type=5")

        let editionType = EditionType(rawValue: page.edType) ?? .original
        let flags:[UIImage?] = page.flags != nil ? createFlagImages(fromIds: page.flags):[]
        
        return PageViewModel(id:page.id,pageNumber: page.pageNumber, name: page.name, section:sectionName,
                             part: page.part, edition: page.edition,
                             version: page.version, template:template,
                             editionType: editionType,statusName: statusName, statusColor: statusColor, flags: flags,
                              thumbUrl: thumbUrl, previewUrl: previewUrl)
    }
    
    
    func createFlagImages(fromIds inIds:[Int]?) -> [UIImage?] {
        guard let ids = inIds else {
            return []
        }
        var images:[UIImage?] = []
        
        for entityFlag in flags {
            if ids.contains(entityFlag.id) {
                images.append(entityFlag.onImage)
            }else if (entityFlag.offImage != nil) {
                images.append(entityFlag.offImage)
            }else if (entityFlag.fillSpace) {
                images.append(nil)
            }
        }
        return images
        
        
        
    }
    
//    private func intToColor(value: Int) -> UIColor {
//        let value = value | 255 << 24
//        return UIColor(
//            red: CGFloat(CGFloat((value & 255 << 16) >> 16) / 255.0),
//            green: CGFloat(CGFloat((value & 255 << 8) >> 8) / 255.0),
//            blue: CGFloat(CGFloat((value & 255 << 0) >> 0) / 255.0),
//            alpha: 1.0
//        )
//    }
}
