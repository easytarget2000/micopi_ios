import ContactsUI
import UIKit

class ContactPickerWrapper: NSObject {
    
    // MARK: - Values
    
    var contactCNConverter = ContactCNConverter()
    weak var delegate: ContactPickerWrapperDelegate?
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let imagePreviewViewController
//            = segue.destination as? ImagePreviewViewController {
//
//            let contactWrapper = sender as! ContactHashWrapper
//            imagePreviewViewController.contactWrapper = contactWrapper
//        } else if let batchGeneratorViewController
//            = segue.destination as? BatchGeneratorViewController {
//
//
//        }
//    }
    
    // MARK: Implementations
    
    func showContactPicker(sourceViewController: UIViewController) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        sourceViewController.present(
            contactPickerViewController,
            animated: true,
            completion: nil
        )
    }
    
    fileprivate func handleContactsSelection(_ cnContacts: [CNContact]) {
        if cnContacts.isEmpty {

        } else if cnContacts.count == 1 {
            convertAndForwardCNContact(cnContacts.first!)
        } else {
            convertAndForwardCNContacts(cnContacts)
        }
    }
    
    fileprivate func convertAndForwardCNContact(_ cnContact: CNContact) {
        let contactWrapper
            = contactCNConverter.convertCNContactWrapped(cnContact)
        
        DispatchQueue.main.async {
            self.delegate?.contactPickerWrapper(self, didSelect: contactWrapper)
        }
    }
    
    fileprivate func convertAndForwardCNContacts(_ cnContacts: [CNContact]) {
        let contactWrappers
            = contactCNConverter.convertCNContactsWrapped(cnContacts)
        DispatchQueue.main.async {
            self.delegate?.contactPickerWrapper(
                self,
                didSelect: contactWrappers
            )
        }
    }
    
    fileprivate func handleCancellation() {
        DispatchQueue.main.async {
            self.delegate?.contactPickerWrapperDidCancel(self)
        }
    }
    
}

// MARK: - CNContactPickerDelegate

extension ContactPickerWrapper: CNContactPickerDelegate {
    
    func contactPicker(
        _ picker: CNContactPickerViewController,
        didSelect contacts: [CNContact]
    ) {
        picker.dismiss(
            animated: true,
            completion: {
                self.handleContactsSelection(contacts)
            }
        )
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(
            animated: true,
            completion: {
                self.handleCancellation()
            }
        )
    }
}
