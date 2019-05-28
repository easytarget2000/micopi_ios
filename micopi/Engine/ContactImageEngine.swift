import UIKit.UIImage

struct ContactImageEngine {
    
    static let defaultImageSize = CGFloat(1600)
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    var initialsFont = UIFont(name: "HelveticaNeue-Light", size: 600)!
    var initialsFontSizeFactorBase = CGFloat(0.66)
    var initialsTextColor = UIColor.white
    
    func generateImageForContactAsync(
        contactWrapper: ContactHashWrapper,
        size: CGFloat = ContactImageEngine.defaultImageSize,
        completionHandler: @escaping (UIImage) -> ()
    ) {
        globalDispatchQueue.async {
            // Background thread
            
            let generatedImage = self.generateImageForContact(
                contactWrapper: contactWrapper,
                size: size
            )
            
            self.mainDispatchQueue.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func generateImageForContact(
        contactWrapper: ContactHashWrapper,
        size: CGFloat = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        
        return UIImage()
    }
    
    fileprivate func paintInitials(_ initials: String, imageSize: CGFloat) {
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
