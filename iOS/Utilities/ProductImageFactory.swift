
import Foundation
import Cocoa
import UIKit

class ProductImageFactory {
    static let shared = ProductImageFactory()
    
    private init(){}
    
    func getProductImage(fromProductName productName:String) -> UIImage? {
        
        var upperCaseCharacters: String = productName.upperCasedCharacters
        if (upperCaseCharacters.count > 3) {
           upperCaseCharacters = String(upperCaseCharacters.prefix(2))+String(upperCaseCharacters.last!)
        }
        return getImage(fromString: upperCaseCharacters)
        
    }
    
    func getImage(fromString string:String) -> UIImage? {
        let textImage = createImage(withText: string)
        
        let newSize = CGSize(width: 50, height: 50)   // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let frame = CGRect(origin: CGPoint.zero, size: newSize)
        
        if let gradientImage = primaryGradient(withFrame:frame) {
            gradientImage.draw(in: frame)
        }
        textImage.draw(in: frame)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage
    }
    
    private func createImage(withText text:String) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50 , height: 50))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [
                NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 15)!, NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            
            text.draw(with: CGRect(x: 0, y: 15, width: 50, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        
        return img
    }
    
    
    private func primaryGradient(withFrame frame:CGRect) -> UIImage? {
        let gradient = CAGradientLayer()
        
        let flareRed = UIColor(displayP3Red: 88.0/255.0, green: 142.0/255.0, blue: 166.0/255.0, alpha: 1.0)
        let flareOrange = UIColor(displayP3Red: 39.0/255.0, green: 141.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        
        //        let flareRed = UIColor(displayP3Red: 241.0/255.0, green: 39.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        //        let flareOrange = UIColor(displayP3Red: 245.0/255.0, green: 175.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        
        //        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = frame
        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return createGradientImage(in: frame, with: gradient)
    }
    
    private func createGradientImage(in frame: CGRect, with gradient:CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradient.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    func resize(image:UIImage,to newSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
