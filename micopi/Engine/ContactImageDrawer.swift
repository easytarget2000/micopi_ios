import UIKit.UIImage

class ContactImageDrawer {
    
    static let defaultImageSize = Float(1600)
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    var initialsFont = UIFont(name: "HelveticaNeue-Light", size: 600)!
    var initialsFontSizeFactorBase = CGFloat(0.66)
    var initialsTextColor = UIColor.black//UIColor.white
    fileprivate var stopped = false
    
    func drawImageForContactAsync(
        contactWrapper: ContactHashWrapper,
        imageSize: Float = ContactImageDrawer.defaultImageSize,
        completionHandler: @escaping (UIImage) -> ()
    ) {
        globalDispatchQueue.async {
            // Background thread
            
            let generatedImage = self.drawImageForContact(
                contactWrapper: contactWrapper,
                imageSize: imageSize
            )
            
            self.mainDispatchQueue.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func stop() {
        stopped = true
    }
    
    func drawImageForContact(
        contactWrapper: ContactHashWrapper,
        imageSize: Float = ContactImageDrawer.defaultImageSize
    ) -> UIImage {
        stopped = false
        let cgImageSize = CGFloat(imageSize)
        let contextSize = CGSize(width: cgImageSize, height: cgImageSize)
    
        UIGraphicsBeginImageContext(contextSize)
        
        let displayedInitials = "ABC"
        paintInitials(displayedInitials, imageSize: cgImageSize)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return generatedImage
    }
    
    fileprivate func paintInitials(_ initials: String, imageSize: CGFloat) {
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
