import UIKit

typealias AlertCallback = (UIAlertController) -> ()

class ContactHashWrapperViewModel: NSObject {
    
    var contactWrapper: ContactHashWrapper! {
        didSet {
            initValues()
        }
    }
    @IBOutlet var contactViewModel: ContactViewModel!
    @IBOutlet var imageEngine: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    @IBOutlet var storageCommunicator: PhotoStorageCommunicator!
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
        guard !(isGenerating.value ?? false),
            let generatedImage = generatedImage.value ?? nil else {
            return false
        }
        
        return contactWriter.assignImage(
            generatedImage,
            toContact: contactWrapper.cnContact
        )
    }
    
    func saveImageToStorage(callback: @escaping AlertCallback) {
        guard !(isGenerating.value ?? false),
            let generatedImage = generatedImage.value ?? nil else {
                return
        }
        
        storageCommunicator.saveImage(
            generatedImage,
            callback: {
                (errorMessage) in
                self.handleStorageCallback(
                    errorMessage: errorMessage,
                    callback: callback
                )
            }
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
        
        contactImageDrawer.contactWrappers = [contactWrapper]
        contactImageDrawer.generateAndDrawAsync(
            callback: {
                (_, generatedImage, completed, _) in
                self.generatedImage.value = generatedImage
                self.isGenerating.value = !completed
            }
        )
    }
    
    fileprivate func handleStorageCallback(
        errorMessage: String?,
        callback: @escaping AlertCallback
    ) {
        let alertTitle: String?
        let alertMessage: String
        let okButtonTitle = NSLocalizedString(
            "ok_button",
            comment: "OK"
        )
        
        if let errorMessage = errorMessage {
            alertTitle = nil
            alertMessage = errorMessage
        } else {
            alertTitle = NSLocalizedString(
                "assign_confirmation_title",
                comment: "Done"
            )
            alertMessage = NSLocalizedString(
                "save_confirmation_message",
                comment: "Done saving to Photos."
            )
        }
        
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: okButtonTitle,
            style: .cancel,
            handler: nil
        )
        alert.addAction(alertAction)
        
        callback(alert)
    }
    
}
