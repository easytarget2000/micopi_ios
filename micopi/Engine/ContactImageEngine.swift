import UIKit.UIImage

struct ContactImageEngine {
    
    static let defaultImageSize = CGFloat(1600)
    
    func generateImageForContact(
        _ contact: Contact,
        size: CGFloat = ContactImageEngine.defaultImageSize,
        completionHandler: @escaping (UIImage) -> ()
    ) {
        DispatchQueue.global().async {
            // Background thread
            
            let generatedImage = self.generateImageForContactSynchronized(
                contact: contact,
                size: size
            )
            
            DispatchQueue.main.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func generateImageForContactSynchronized(
        contact: Contact,
        size: CGFloat = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        
        return UIImage()
    }
    
}
