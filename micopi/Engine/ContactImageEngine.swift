import UIKit.UIImage

struct ContactImageEngine {
    
    static let defaultImageSize = CGFloat(1600)
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    
    func generateImageForContactAsync(
        _ contact: Contact,
        size: CGFloat = ContactImageEngine.defaultImageSize,
        completionHandler: @escaping (UIImage) -> ()
    ) {
        globalDispatchQueue.async {
            // Background thread
            
            let generatedImage = self.generateImageForContact(
                contact: contact,
                size: size
            )
            
            self.mainDispatchQueue.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func generateImageForContact(
        contact: Contact,
        size: CGFloat = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        
        return UIImage()
    }
    
}
