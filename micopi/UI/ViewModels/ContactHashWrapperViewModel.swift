import UIKit

class ContactHashWrapperViewModel: NSObject {
    
    var contactWrapper: ContactHashWrapper! {
        didSet {
            initValues()
        }
    }
    @IBOutlet var contactImageDrawer: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    var displayName: Dynamic<String> = Dynamic("")
    fileprivate(set) var generatedImage: Dynamic<UIImage?> = Dynamic(nil)
    
    func generatePreviousImage() {
        contactWrapper.decreaseModifier()
        generateImage()
    }
    
    func generateNextImage() {
        contactWrapper.increaseModifier()
        generateImage()
    }
    
    func assignImageToContact() {
        guard let generatedImage = generatedImage.value ?? nil else {
            return
        }
        
        contactWriter.assignImage(
            generatedImage,
            toContact: contactWrapper.contact
        )
    }
    
    fileprivate func initValues() {
        displayName.value = contactWrapper.contact.fullName
        generateImage()
    }
    
    fileprivate func generateImage() {
        contactImageDrawer.drawImageForContactAsync(
            contactWrapper: contactWrapper,
            completionHandler: {
                (generatedImage) in
                self.generatedImage.value = generatedImage
            }
        )
    }
}
