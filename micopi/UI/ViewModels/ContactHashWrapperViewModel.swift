import UIKit

class ContactHashWrapperViewModel: NSObject {
    
    var contactWrapper: ContactHashWrapper! {
        didSet {
            initValues()
        }
    }
    @IBOutlet var contactViewModel: ContactViewModel!
    @IBOutlet var imageEngine: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    var isGenerating: Dynamic<Bool> = Dynamic(false)
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
    
    func assignImageToContact() -> Bool {
        guard let generatedImage = generatedImage.value ?? nil else {
            return false
        }
        
        return contactWriter.assignImage(
            generatedImage,
            toContact: contactWrapper.cnContact
        )
    }
    
    fileprivate func initValues() {
        var displayName = contactViewModel.displayName(
            contact: contactWrapper.contact
        )
        if contactWrapper.contact.hasPicture {
            let hasPictureMessage = NSLocalizedString(
                "preview_contact_has_picture_message",
                comment: "Contact has image warning"
            )
            displayName += "\n\(hasPictureMessage)"
        }
        
        self.displayName.value = displayName
        generateImage()
    }
    
    fileprivate func generateImage() {
        guard !(isGenerating.value ?? false) else {
            return
        }
        
        guard let contactImageDrawer = imageEngine else {
            return
        }
        
        isGenerating.value = true
//        generatedImage.value = nil
        
        contactImageDrawer.contactWrappers = [contactWrapper]
        contactImageDrawer.generateAndDrawAsync(
            callback: {
                (_, generatedImage, completed, _) in
                self.generatedImage.value = generatedImage
                self.isGenerating.value = !completed
            }
        )
    }
    
}
