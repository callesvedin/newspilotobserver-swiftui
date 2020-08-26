//
//  ContentView.swift
//  PieChart
//
//  Created by carl-johan.svedin on 2020-07-15.
//

import SwiftUI

struct ContentView: View {
    @State var expandChart:Bool = true
    var data:[PieChartItem] = []
    let pieChartModel:PieChartModel
    
    init() {
        let values:[Double] = [11, 12, 13, 14, 15, 16]
        for value in values {
            data.append(PieChartItem(title: "The status \(Int(value))",value: value, color: .random))
        }
        pieChartModel = PieChartModel(data: data)
    }
    
    var body: some View {
        VStack {
            Text("Hello, world 2!").font(.title).padding()
            Button(action:{
                withAnimation {
                    expandChart.toggle()
                }
                
            }) {
                PieChartView(chartData:pieChartModel).frame(width: 50, height: 50)
            }
            
            if expandChart {
                ForEach(pieChartModel.arcData) {arc in
                    HStack {
                        Arc(startAngle: arc.startAngle, endAngle: arc.endAngle, clockwise: true)
                            .foregroundColor(Color(arc.pieData.color))
                            .frame(width: 30, height: 30, alignment: .center).padding(0)
                            
                        Text("\(Int(arc.pieData.value)) is \(arc.pieData.title)")
                        Spacer()
                    }.padding(.leading, 5)
                }
            }
            
            List {
                ForEach(pieChartModel.arcData) { stuff in
                    Text("Stuff: \(stuff.pieData.title)")
                }
            }
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
