import UIKit

class ContactHashWrapperViewModel: NSObject {
    
    var contactWrapper: ContactHashWrapper!
    @IBOutlet var contactImageDrawer: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    var displayName: String {
        get {
            return contactWrapper.contact.fullName
        }
    }
    fileprivate(set) var generatedImage: UIImage?

    func populateDisplayNameLabel(_ targetView: UILabel) {
        targetView.text = displayName
    }
    
    func generateImage(targetView: UIImageView) {
        contactImageDrawer.drawImageForContactAsync(
            contactWrapper: contactWrapper,
            completionHandler: {
                (generatedImage) in
                self.generatedImage = generatedImage
                targetView.image = self.generatedImage
            }
        )
    }
    
    func generatePreviousImage(targetView: UIImageView) {
        contactWrapper.decreaseModifier()
        generateImage(targetView: targetView)
    }
    
    func generateNextImage(targetView: UIImageView) {
        contactWrapper.increaseModifier()
        generateImage(targetView: targetView)
    }
    
    func assignImageToContact() {
        guard let generatedImage = generatedImage else {
            return
        }
        
        contactWriter.assignImage(
            generatedImage,
            toContact: contactWrapper.contact
        )
    }
}
