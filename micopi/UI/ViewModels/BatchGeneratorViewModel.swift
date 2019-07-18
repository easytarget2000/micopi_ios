import Foundation

class BatchGeneratorViewModel: NSObject {
    
    var contactWrappers: [ContactHashWrapper]! {
        didSet {
            initValues()
        }
    }
    var statusMessage = Dynamic("")
    var buttonTitle = Dynamic("")
    var isGenerating = Dynamic(false)
    var currentlyProcessedContact: Contact?
    var processedContacts: [Contact]?
    @IBOutlet var contactViewModel: ContactViewModel!

    func initValues() {
        setStatusMessage()
        setButtonTitle()
    }
    
    func handleButtonTouch() {
        
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
    
    fileprivate func lineForContact(
        _ contact: Contact
    ) -> String {
        let lineFormat: String
        if contact == currentlyProcessedContact {
            lineFormat = NSLocalizedString(
                "batch_name_processing_format",
                comment: "\n%@ (processing)"
            )
        } else if processedContacts?.contains(contact) ?? false {
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
}
