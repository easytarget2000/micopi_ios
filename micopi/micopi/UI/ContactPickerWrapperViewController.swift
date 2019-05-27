import ContactsUI
import UIKit

class ContactPickerWrapperViewController: UIViewController {
    
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
        
    }
    
    fileprivate func convertAndForwardCNContacts(_ cnContacts: [CNContact]) {
        
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
