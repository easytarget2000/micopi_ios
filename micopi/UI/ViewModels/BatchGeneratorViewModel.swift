import UIKit.UIImage

class BatchGeneratorViewModel: NSObject {
    
    static let startButtonColor = UIColor(named: "PositiveButton")!
    static let stopButtonColor = UIColor.red//(named: "NegativeButton")!
    var contactWrappers: [ContactHashWrapper]! {
        didSet {
            setStatusAndButtonProperties()
        }
    }
    var statusMessage = Dynamic("")
    var buttonTitle = Dynamic("")
    var buttonColor = Dynamic(BatchGeneratorViewModel.startButtonColor)
    var isGenerating = Dynamic(false)
    var currentlyProcessedContact: Contact? {
        didSet {
            self.setStatusAndButtonProperties()
        }
    }
    var processedContacts = [Contact]()
    @IBOutlet var contactViewModel: ContactViewModel!
    @IBOutlet var imageEngine: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    
    func setStatusAndButtonProperties() {
        setStatusMessage()
        setButtonProperties()
    }
    
    func handleButtonTouch() {
        if isGenerating.value ?? false {
            stopGeneratingImages()
        } else {
            generateImages()
        }
        setButtonProperties()
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
    
    fileprivate func setButtonProperties() {
        let buttonTitle: String
        let buttonColor: UIColor
        if isGenerating.value ?? false {
            buttonTitle = NSLocalizedString(
                "batch_stop_button",
                comment: "Stop Process"
            )
            buttonColor = BatchGeneratorViewModel.stopButtonColor
        } else {
            buttonTitle = NSLocalizedString(
                "batch_start_button",
                comment: "Start Process"
            )
            buttonColor = BatchGeneratorViewModel.startButtonColor
        }
        self.buttonTitle.value = buttonTitle
        self.buttonColor.value = buttonColor
    }
    
    fileprivate func generateImages() {
        isGenerating.value = true
        
        processedContacts = []
        imageEngine.contactWrappers = contactWrappers
        imageEngine.generateAndDrawAsync(
            callback: {
                (contactWrapper, generatedImage, completed, completedLast) in
                self.handleCallback(
                    contactWrapper,
                    generatedImage,
                    completed,
                    completedLast
                )
            }
        )
        
    }
    
    fileprivate func stopGeneratingImages() {
        imageEngine.stop()
        currentlyProcessedContact = nil
        isGenerating.value = false
        setStatusAndButtonProperties()
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
    
    fileprivate func handleCallback(
        _ contactWrapper: ContactHashWrapper?,
        _ generatedImage: UIImage?,
        _ completed: Bool,
        _ completedLast: Bool
    ) {
        if completedLast {
            isGenerating.value = false
            currentlyProcessedContact = nil
            setStatusAndButtonProperties()
        } else {
            currentlyProcessedContact = contactWrapper!.contact
        }
        
        guard completed,
            let generatedImage = generatedImage,
            let contactWrapper = contactWrapper
        else {
            return
        }
        
        assignImage(generatedImage, toContact: contactWrapper)
    }
}
