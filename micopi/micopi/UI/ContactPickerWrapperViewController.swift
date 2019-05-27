import ContactsUI
import UIKit

class ContactPickerWrapperViewController: UIViewController {
    
    fileprivate static let toImagePreviewSegue
        = "ContactPickerToImagePreviewSegue"
    var contactCNConverter = ContactCNConverter()

    override func viewDidLoad() {
        super.viewDidLoad()
        showContactPicker()
    }
    
    fileprivate func showContactPicker() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true, completion: nil)
    }
    
    fileprivate func close() {
        dismiss(animated: false, completion: nil)
    }
    
    fileprivate func convertAndForwardCNContact(_ cnContact: CNContact) {
        let contactWrapper
            = contactCNConverter.convertCNContactWrapped(cnContact)
        
        performSegue(
            withIdentifier:
                ContactPickerWrapperViewController.toImagePreviewSegue,
            sender: contactWrapper
        )
    }
    
    fileprivate func convertAndForwardCNContacts(_ cnContacts: [CNContact]) {
        let contactWrappers
            = contactCNConverter.convertCNContactsWrapped(cnContacts)
        
    }
}

// MARK: - CNContactPickerDelegate

extension ContactPickerWrapperViewController: CNContactPickerDelegate {
    
    func contactPicker(
        _ picker: CNContactPickerViewController,
        didSelect contact: CNContact
    ) {
        convertAndForwardCNContact(contact)
    }
    
    func contactPicker(
        _ picker: CNContactPickerViewController,
        didSelect contacts: [CNContact]
    ) {
        convertAndForwardCNContacts(contacts)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        close()
    }
}
