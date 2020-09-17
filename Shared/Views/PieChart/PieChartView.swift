//
//  PieChartView.swift
//  PieChart
//
//  Created by carl-johan.svedin on 2020-07-15.
//

import SwiftUI

class PieChartItem:PieChartData, Identifiable {
    public let id:UUID = UUID.init()
    var value:Double
    var title:String
    var color:UIColor
    
    init(title:String, value:Double, color:UIColor) {
        self.title = title
        self.value = value
        self.color = color
    }
    
}

class ArcData:Identifiable {
    init() {
    }
    
    public let id:UUID = UUID.init()
    var pieData:PieChartData!
    var startAngle:Angle!
    var endAngle:Angle!
    var annotationDeltaX:CGFloat!
    var annotationDeltaY:CGFloat!
    //    var percentTitle:String!
}

struct PieChartView: View {
    @ObservedObject var chartData:PieChartModel
    
    var body: some View {
        
        return
            GeometryReader {geometry in
                ZStack {
                    ForEach(chartData.arcData) {arc in
                        Arc(startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: true)
                            .fill(Color(arc.pieData.color),opacity:1, strokeWidth: 1, strokeColor: Color.gray)
                    }
                    
                    if geometry.size.width >= 200 {
                        ForEach(chartData.arcData) { arc in
                            Text(arc.pieData.title)
                                .foregroundColor(Color.white)
                                .position(CGPoint(x: geometry.size.width / 2 + arc.annotationDeltaX*geometry.size.width/2,
                                                  y: geometry.size.height / 2 + arc.annotationDeltaY*geometry.size.height/2))
                        }
                    }
                }
                
            }
    }
}


extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let values:[Double] = [11, 12, 13, 14, 15, 16]
        var data:[PieChartData] = []
        
        for value in values {
            
            data.append(PieChartItem(title: "\(Int(value))",value: value, color: .random))
        }
        
        return
            PieChartView(chartData: PieChartModel(data: data))
            .frame(width: 200, height: 200, alignment: .center)
    }
}
