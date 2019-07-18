import UIKit.UIImage

class BatchGeneratorViewModel: NSObject {
    
    var contactWrappers: [ContactHashWrapper]! {
        didSet {
            initValues()
        }
    }
    var statusMessage = Dynamic("")
    var buttonTitle = Dynamic("")
    var isGenerating = Dynamic(false)
    var currentlyProcessedContact: Contact? {
        didSet {
            self.setStatusMessage()
        }
    }
    var processedContacts = [Contact]()
    @IBOutlet var contactViewModel: ContactViewModel!
    @IBOutlet var imageEngine: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    
    func initValues() {
        setStatusMessage()
        setButtonTitle()
    }
    
    func handleButtonTouch() {
        if isGenerating.value ?? false {
            stopGeneratingImages()
        } else {
            generateImages()
        }
        setButtonTitle()
    }
    
    fileprivate func setStatusMessage() {
        var statusMessage = NSLocalizedString(
            "batch_start_message",
            comment: "Selected"
        )
        statusMessage += "\n"
        for contactWrapper in contactWrappers {
            statusMessage += lineForContact(contactWrapper.contact)
        }
        self.statusMessage.value = statusMessage
    }
    
    fileprivate func setButtonTitle() {
        let buttonTitle: String
        if isGenerating.value ?? false {
            buttonTitle = NSLocalizedString(
                "batch_stop_button",
                comment: "Stop Process"
            )
        } else {
            buttonTitle = NSLocalizedString(
                "batch_start_button",
                comment: "Start Process"
            )
        }
        self.buttonTitle.value = buttonTitle
    }
    
    fileprivate func generateImages() {
        isGenerating.value = true
        
        processedContacts = []
        imageEngine.contactWrappers = contactWrappers
        imageEngine.generateAndDrawAsync(
            callback: {
                (contactWrapper, generatedImage, completed, completedLast) in
                self.currentlyProcessedContact = contactWrapper.contact
                
                guard completed else {
                    return
                }
                self.assignImage(generatedImage, toContact: contactWrapper)
                
                guard completedLast else {
                    return
                }
                
                self.handleCompletion()
            }
        )
        
    }
    
    fileprivate func stopGeneratingImages() {
        imageEngine.stop()
        currentlyProcessedContact = nil
    }
    
    fileprivate func lineForContact(
        _ contact: Contact
    ) -> String {
        let lineFormat: String
        if contact == currentlyProcessedContact {
            lineFormat = NSLocalizedString(
                "batch_name_processing_format",
                comment: "\n%@ (processing)"
            )
        } else if processedContacts.contains(contact) {
            lineFormat = NSLocalizedString(
                "batch_name_completed_format",
                comment: "\n%@ (done)"
            )
        } else {
            lineFormat = NSLocalizedString(
                "batch_name_default_format",
                comment: "\n%@"
            )
        }
        
        let contactDisplayName = contactViewModel.displayName(contact: contact)
        return String(format: lineFormat, contactDisplayName)
    }
    
    fileprivate func assignImage(
        _ image: UIImage,
        toContact contactWrapper: ContactHashWrapper
    ) {
        let didAssign = contactWriter.assignImage(
            image,
            toContact: contactWrapper.cnContact
        )
        
        if didAssign {
            processedContacts.append(contactWrapper.contact)
        }
        setStatusMessage()
    }
    
    fileprivate func handleCompletion() {
        isGenerating.value = false
        currentlyProcessedContact = nil
        setButtonTitle()
    }
}
