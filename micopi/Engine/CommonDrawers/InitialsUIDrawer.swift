import CoreGraphics
import UIKit.UIFont

class InitialsUIDrawer: NSObject {
    
    var initialsFont = UIFont(name: "HelveticaNeue-Light", size: 600)!
    var initialsFontSizeFactorBase = CGFloat(0.66)
    var initialsTextColor = UIColor.white
    
    func drawInitialsInImageContext(_ initials: String, imageSize: CGFloat) {
        guard !initials.isEmpty else {
            return
        }
        
        let fontSizeFactor = pow(
            initialsFontSizeFactorBase,
            CGFloat(initials.count)
        )
        let fontSize = imageSize * fontSizeFactor
        let resizedInitialsFont = initialsFont.withSize(fontSize)
        
        let fontAttributes = [
            NSAttributedString.Key.font : resizedInitialsFont,
            NSAttributedString.Key.foregroundColor : initialsTextColor
        ]
        
        let stringSize = initials.size(withAttributes: fontAttributes)
        let initialsRect = CGRect(
            x: (imageSize - stringSize.width) / 2,
            y: (imageSize - stringSize.height) / 2,
            width: stringSize.width,
            height: stringSize.height
        )
        initials.draw(in: initialsRect, withAttributes: fontAttributes)
    }
}
