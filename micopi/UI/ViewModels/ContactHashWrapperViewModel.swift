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
        displayName.value = contactViewModel.displayName(
            contact: contactWrapper.contact
        )
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
