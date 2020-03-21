import Foundation
import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 15
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        print("animatableData:\(animatableData)")
        let xTransform = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        print("xTransform:\(xTransform)")
        return ProjectionTransform(CGAffineTransform(translationX: xTransform, y: 0))
    }
}
