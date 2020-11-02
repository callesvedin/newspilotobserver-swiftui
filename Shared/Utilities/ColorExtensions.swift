import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

import SwiftUI

extension Color {
    public static let navigaButtonBackground = Color("NavigaButtonBackground")
    // Går inte att använda med .navigaBackground (knappen försvinner)
    public static let navigaPressedButtonBackground = Color("NavigaPressedButtonBackground")
    public static let navigaBackground = Color("NavigaBackground")
    public static let navigaTextFieldBackground = Color.secondary
}


extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

#if os(macOS)
extension NSColor {
    static var random: NSColor {
        return NSColor(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1),
                     alpha: 1)
    }
}


extension NSColor {
    
    public static func intToColor(value: Int) -> NSColor {
        let value = value | 255 << 24
        return NSColor(
            red: CGFloat(CGFloat((value & 255 << 16) >> 16) / 255.0),
            green: CGFloat(CGFloat((value & 255 << 8) >> 8) / 255.0),
            blue: CGFloat(CGFloat((value & 255 << 0) >> 0) / 255.0),
            alpha: 1.0
        )
    }
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



#else
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1),
                     alpha: 1)
    }
}


extension UIColor {
    
    public static func intToColor(value: Int) -> UIColor {
        let value = value | 255 << 24
        return UIColor(
            red: CGFloat(CGFloat((value & 255 << 16) >> 16) / 255.0),
            green: CGFloat(CGFloat((value & 255 << 8) >> 8) / 255.0),
            blue: CGFloat(CGFloat((value & 255 << 0) >> 0) / 255.0),
            alpha: 1.0
        )
    }
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
#endif
