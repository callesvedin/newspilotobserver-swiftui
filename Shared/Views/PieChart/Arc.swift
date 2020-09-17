//
//  PieChartShard.swift
//  PieChart
//
//  Created by carl-johan.svedin on 2020-07-15.
//

import SwiftUI

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let modifiedStart = startAngle
        let modifiedEnd = endAngle

        var path = Path()
        path.move(to: CGPoint(x:rect.midX, y:rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        path.addLine(to: CGPoint(x:rect.midX, y:rect.midY))
        return path
    }
}

struct Arc_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        Arc(startAngle: .degrees(0), endAngle: .degrees(45), clockwise: true)
//            .stroke(Color.blue, lineWidth: 1)
            .foregroundColor(.random)
            .frame(width: 300, height: 300)
        Arc(startAngle: .degrees(0), endAngle: .degrees(45), clockwise: true)
                .stroke(Color.gray, lineWidth: 1)
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                

        }
    }
}
