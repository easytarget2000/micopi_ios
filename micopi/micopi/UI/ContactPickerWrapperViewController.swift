import ContactsUI
import UIKit

class ContactPickerWrapperViewController: UIViewController {
    
    fileprivate static let toImagePreviewSegue
        = "ContactPickerToImagePreviewSegue"
    var contactCNConverter = ContactCNConverter()
    fileprivate var showContactPickerOnAppear = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showContactPickerOnAppear {
            showContactPickerOnAppear = false
            showContactPicker()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagePreviewViewController
            = segue.destination as? ImagePreviewViewController {
            
            let contactWrapper = sender as! ContactHashWrapper
            imagePreviewViewController.contactWrapper = contactWrapper
        }
        
        super.prepare(for: segue, sender: sender)
    }
}

// MARK: - CNContactPickerDelegate

extension ContactPickerWrapperViewController: CNContactPickerDelegate {
    
    func contactPicker(
        _ picker: CNContactPickerViewController,
        didSelect contacts: [CNContact]
    ) {
        if contacts.isEmpty {
            close()
        } else if contacts.count == 1 {
            convertAndForwardCNContact(contacts.first!)
        } else {
            convertAndForwardCNContacts(contacts)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        close()
    }
}
