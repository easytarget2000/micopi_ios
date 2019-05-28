import UIKit.UIImage

struct ContactImageEngine {
    
    static let defaultImageSize = CGFloat(1600)
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    
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
    
}
