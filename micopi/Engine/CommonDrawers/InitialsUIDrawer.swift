import CoreGraphics
import UIKit.UIFont

class InitialsUIDrawer: NSObject {
    
    var initialsFont = UIFont(name: "ArialRoundedMTBold", size: 512)!
    var initialsFontSizeFactorBase = CGFloat(0.55)
    
    func drawInitialsInImageContext(
        _ initials: String,
        color: ARGBColor,
        imageSize: CGFloat
    ) {
        guard !initials.isEmpty else {
            return
        }
        
        let fontSizeFactor = pow(
            initialsFontSizeFactorBase,
            CGFloat(initials.count)
        )
        let fontSize = imageSize * fontSizeFactor
        let resizedInitialsFont = initialsFont.withSize(fontSize)
        
        let uiColor = UIColor(
            red: CGFloat(color.r),
            green: CGFloat(color.g),
            blue: CGFloat(color.b),
            alpha: CGFloat(color.a)
        )
        
        let fontAttributes = [
            NSAttributedString.Key.font : resizedInitialsFont,
            NSAttributedString.Key.foregroundColor : uiColor
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
