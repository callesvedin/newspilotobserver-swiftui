
import Foundation
import Cocoa

class ProductImageFactory {
    static let shared = ProductImageFactory()
    private let imageSize = NSSize(width: 50, height: 50)
    private init(){}
    
    func getProductImage(fromProductName productName:String) -> UIImage? {
        
        var upperCaseCharacters: String = productName.upperCasedCharacters
        if (upperCaseCharacters.count > 3) {
           upperCaseCharacters = String(upperCaseCharacters.prefix(2))+String(upperCaseCharacters.last!)
        }
        return getImage(fromString: upperCaseCharacters)
        
    }
    
    private func getImage(fromString string:String) -> NSImage? {
        let textImage = createImage(withText: string)
                
        let frame = CGRect(origin: CGPoint.zero, size: textImage.size)
        let newImage = NSImage(size: frame.size)
        newImage.lockFocus()
        
        if let gradientImage = primaryGradient(withFrame: frame) {
            gradientImage.draw(in: frame)
        }
        textImage.draw(in: frame)
        newImage.unlockFocus()
        
        return newImage
    }
    
    
    
    private func createImage(withText text:String) -> NSImage {
        let targetImage = NSImage(size: imageSize)
        targetImage.lockFocus()
        targetImage.draw(in:NSRect(x:0,y:0,width: imageSize.width,height: imageSize.height))
        let textColor = NSColor.white
        let textFont = NSFont(name: "Verdana-Bold", size: 15)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center

        let attrs = [
            NSAttributedString.Key.foregroundColor:textColor,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let textOrigin = CGPoint(x: imageSize.height/3, y: -imageSize.width/4)
        let rect = CGRect(origin: textOrigin, size: imageSize)
        text.draw(in: rect, withAttributes: attrs)
        targetImage.unlockFocus()
        return targetImage
    }
    
    
    private func primaryGradient(withFrame frame:CGRect) -> NSImage? {
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
    
    private func createGradientImage(in frame: CGRect, with gradient:CAGradientLayer) -> NSImage? {
        
        var gradientImage = UIImage(size: frame.size)
//        let path = NSBezierPath(rect: frame)
            

        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(frame.size.width),
                                        pixelsHigh: Int(frame.size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSColorSpaceName.calibratedRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)


        gradientImage.addRepresentation(rep!)
        gradientImage.lockFocus()

        let rect = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        guard let ctx = NSGraphicsContext.current?.cgContext else{
            print("WTF? No context")
            return nil
        }
//        ctx!.clear(rect)
//        ctx!.setFillColor(NSColor.black.cgColor)
//        ctx!.fill(rect)


        gradient.render(in: ctx)
        
        gradientImage.unlockFocus()
             
        
        return gradientImage
    }
    
    
    /*
     extension NSImage {
         convenience init?(gradientColors: [NSColor], imageSize: NSSize) {
             guard let gradient = NSGradient(colors: gradientColors) else { return nil }
             let rect = NSRect(origin: CGPoint.zero, size: imageSize)
             self.init(size: rect.size)
             let path = NSBezierPath(rect: rect)
             self.lockFocus()
             gradient.draw(in: path, angle: 0.0)
             self.unlockFocus()
         }
     }
     */
    
    
    func resize(image:NSImage,to newSize:CGSize) -> NSImage? {
        var newImage = NSImage(size: newSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, newSize.width, newSize.height),
                   from: NSMakeRect(0, 0, image.size.width, image.size.height),
                         operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = newSize
        return newImage
    }
    
}
