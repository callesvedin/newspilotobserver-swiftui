
import Foundation
import UIKit

struct CellIdentifiers {
    static let PageIcon = "PageIconsTableViewCell"
    static let Standard = "PageDetailViewCell"
}

enum CellType {
    case PageIcon
    case Standard
}

struct PageCellData {
    typealias CellIdentifier = String
    
    let key:String
    let localizedKey:String
    let value:String?
    let cellIdentifier:String
    let cellType:CellType
    let page:PageEntity
    
    init(page:PageEntity, key:String, value:String = "Undefined", cellType:CellType) {
        self.page = page
        self.key = key
        self.value = value
        self.cellType = cellType
        switch cellType {
            case .PageIcon:
                cellIdentifier = CellIdentifiers.PageIcon
            default:
                cellIdentifier = CellIdentifiers.Standard
        }
        
        self.localizedKey = NSLocalizedString(key, comment: key)
    }
}

class PageValueController {
    let keys:Int
    
    private var cellData:[PageCellData]
    
    init(withPage page:PageEntity) {
        cellData = [PageCellData]()
        cellData.append(PageCellData(page:page, key: "id", value: String(Int(exactly: page.entityId) ?? 0), cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "documentName", value: page.documentName ?? "", cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "firstPagin", value: String(Int(exactly: page.firstPagin) ?? 0), cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "edition", value: page.edition ?? "", cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "version", value: page.version ?? "", cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "section", value: page.section?.name ?? "", cellType: CellType.Standard ))
        cellData.append(PageCellData(page:page, key: "part", value: page.part ?? "", cellType: CellType.Standard ))
        
        if let createdDate = page.createdDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" //2018-07-13T08:28:02.908+02:00
            cellData.append(PageCellData(page:page, key: "createdDate", value: formatter.string(from: createdDate as Date), cellType: CellType.Standard ))
        }else{
            cellData.append(PageCellData(page:page, key: "createdDate", value: "", cellType: CellType.Standard ))
        }

        cellData.append(PageCellData(page:page, key:"flags", cellType:CellType.PageIcon))
        keys = cellData.count
    }
    
    func getValueFor(index:Int) -> PageCellData {
        return cellData[index]
    }
    
}
