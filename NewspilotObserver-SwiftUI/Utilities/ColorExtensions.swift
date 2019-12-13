import Foundation
import UIKit


extension UIColor {
    //    Colours on Navigation Bar, Button Titles, Progress Indicator etc.
    static var theme: UIColor {
        return intermidiateBackground
    }

    //Hair line separators in between views.
    static var border: UIColor {
        return UIColor(hexString: "#666666")
    }

    //Shadow colours for card like design.
    static var shadow: UIColor {
        return UIColor(hexString: "#1473E6")
    }
    
    //Dark background colour to group UI components with light colour.
    static var darkBackground: UIColor {
        return UIColor(hexString: "#0C458A")
    }
    
    //Light background colour to group UI components with dark colour.
    static var lightBackground: UIColor {
        return UIColor(hexString: "#E7F1FC")
    }

    //Used for grouping UI elements with some other colour scheme.
    static var intermidiateBackground: UIColor {
        return UIColor(hexString: "#6EAAF2")
    }

    static var lightText: UIColor {
        return UIColor(hexString: "#FFFFFF")
    }
    
    static var darkText: UIColor {
        return UIColor(hexString: "#000000")
    }
    
    static var intermidiateText: UIColor {
        return UIColor(hexString: "#666666")
    }
    
    //Colour to show success, something right for user.
    static var affirmation: UIColor {
        return UIColor(hexString: "#66C47F")
    }
    
    //    Colour to show error, some danger zones for user.
    static var negation: UIColor {
        return UIColor(hexString: "#ED3B3F")
    }

}

extension UIColor {
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(hexString.startIndex, offsetBy: 1)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
