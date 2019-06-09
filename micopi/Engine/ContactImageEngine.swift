import UIKit.UIImage

class ContactImageEngine {
    
    static let defaultImageSize = Float(1600)
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    var initialsDrawer = InitialsDrawer()
    var backgroundColor = UIColor.white.cgColor
    fileprivate var stopped = false
    
    func drawImageForContactAsync(
        contactWrapper: ContactHashWrapper,
        imageSize: Float = ContactImageEngine.defaultImageSize,
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
        imageSize: Float = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        stopped = false
        let cgImageSize = CGFloat(imageSize)
        let contextSize = CGSize(width: cgImageSize, height: cgImageSize)
    
        UIGraphicsBeginImageContext(contextSize)
        let context = UIGraphicsGetCurrentContext()!
        let backgroundDrawer = BackgroundCGDrawer(
            context: context,
            imageSize: cgImageSize
        )
        backgroundDrawer.fillWithColor(backgroundColor)
        
        
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
