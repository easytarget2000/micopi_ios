import UIKit.UIImage

class ContactImageEngine {
    
    static let defaultImageSize = 1600.0
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    var initialsDrawer = InitialsDrawer()
    var colorPalette = ColorPalette()
    fileprivate var stopped = false
    
    func drawImageForContactAsync(
        contactWrapper: ContactHashWrapper,
        imageSize: Double = ContactImageEngine.defaultImageSize,
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
        imageSize: Double = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        stopped = false
        let cgImageSize = CGFloat(imageSize)
        let contextSize = CGSize(width: cgImageSize, height: cgImageSize)
    
        UIGraphicsBeginImageContext(contextSize)
        let context = UIGraphicsGetCurrentContext()!
        
        let backgroundColors = [
            colorPalette.color(randomNumber: 0),
            colorPalette.color(randomNumber: 1)
        ]
        
        let gradientDrawer = GradientDrawer()
        gradientDrawer.drawColors(
            backgroundColors,
            inContext: context,
            size: contextSize
        )
        
        let displayedInitials = "ABC"
        initialsDrawer.drawInitialsInImageContext(
            displayedInitials,
            imageSize: cgImageSize
        )
        
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return generatedImage
    }
    
    
}
