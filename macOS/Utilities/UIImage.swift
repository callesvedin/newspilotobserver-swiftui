import Cocoa
import SwiftUI

typealias UIImage = NSImage


extension Image
{
    init(uiImage image:UIImage) {
        self.init(nsImage: image)
    }
}
