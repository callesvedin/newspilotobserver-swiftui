import Cocoa
import SwiftUI

typealias UIImage = NSImage

extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)

        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }

    convenience init?(named name: String) {
        self.init(named: Name(name))
    }
}

extension Image
{
    init(uiImage image:UIImage) {
        self.init(nsImage: image)
    }
}
