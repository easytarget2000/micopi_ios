import UIKit

class ImageAssignConfirmationViewModel: NSObject {
    
    let okButtonTitle = NSLocalizedString("ok_button", comment: "OK")
    
    func alertForContact(
        contact: Contact?,
        success: Bool
    )  -> UIAlertController {
        let title = titleForContact(contact: contact, success: success)
        let message = messageForContact(contact: contact, success: success)
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: okButtonTitle,
            style: .cancel,
            handler: nil
        )
        alert.addAction(okAction)
        return alert
    }
    
    func titleForContact(contact: Contact?, success: Bool) -> String? {
        if success {
            return NSLocalizedString(
                "assign_confirmation_title",
                comment: "Done"
            )
        } else {
            return nil
        }
    }
    
    func messageForContact(contact: Contact?, success: Bool) -> String {
        if success, let contact = contact {
            let confirmationMessageFormat = NSLocalizedString(
                "assign_confirmation_message_format",
                comment: "%@ has a new image."
            )
            return String(
                format: confirmationMessageFormat,
                contact.givenName
            )
        } else {
            return NSLocalizedString(
                "assign_error_message",
                comment: "Error assigning image."
            )
        }
    }
    
    func messageForContacts(contacts: [Contact], success: Bool) {
        
    }
}
