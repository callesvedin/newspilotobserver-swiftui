//
//  PieChartData.swift
//  PieChart
//
//  Created by carl-johan.svedin on 2020-07-18.
//

import Foundation
import SwiftUI

protocol PieChartData {
    var value:Double { get }
    var title:String { get }
    var color:UIColor { get }
}

class PieChartModel: ObservableObject {
    @Published var arcData:[ArcData] = []
    private var total:Double = 0
    
    init(data:[PieChartData]) {
        total = data.map(\.value).reduce(0.0, +)
        var currentAngle:Double = -90
        for piedata in data {
            let arc = ArcData()
            arc.pieData = piedata
            arc.startAngle = Angle(degrees: currentAngle)
            let angle = piedata.value/total * 360
            let endAngle = currentAngle + angle
            let alpha = currentAngle + angle / 2
            arc.endAngle = Angle(degrees: endAngle)
            
            currentAngle = endAngle
            
            let alphaAngle = Angle(degrees: alpha)
            let deltaX = CGFloat(cos(alphaAngle.radians))
            let deltaY = CGFloat(sin(alphaAngle.radians))
            
            arc.annotationDeltaX = deltaX * 0.7
            arc.annotationDeltaY = deltaY * 0.7
//            arc.percentTitle = String("\(Int(arc.pieData.value / total * 100))%")
            arcData.append(arc)
        }

    }
    
}
