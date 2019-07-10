import ContactsUI
import UIKit

class ContactPickerWrapperViewController: UIViewController {
    
    // MARK: - Values
    
    fileprivate static let toImagePreviewSegue
        = "ContactPickerToImagePreviewSegue"
    fileprivate static let toBatchGeneratorSegue
        = "ContactPickerToBatchGeneratorSegue"
    var contactCNConverter = ContactCNConverter()
    fileprivate var showContactPickerOnAppear = true
    fileprivate var navigateBackToMenuOnAppear = false
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigateBackToMenuOnAppear {
            navigateBackToMenuOnAppear = false
            showContactPickerOnAppear = false
            navigateBackToMenu()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showContactPickerOnAppear {
            showContactPickerOnAppear = false
            showContactPicker()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagePreviewViewController
            = segue.destination as? ImagePreviewViewController {
            
            let contactWrapper = sender as! ContactHashWrapper
            imagePreviewViewController.contactWrapper = contactWrapper
        } else if let batchGeneratorViewController
            = segue.destination as? BatchGeneratorViewController {
            
            
        }
    }
    
    // MARK: Implementations
    
    fileprivate func showContactPicker() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true, completion: nil)
    }
    
    fileprivate func handleContactsSelection(_ cnContacts: [CNContact]) {
        if cnContacts.isEmpty {
            navigateBackToMenu()
        } else if cnContacts.count == 1 {
            convertAndForwardCNContact(cnContacts.first!)
            navigateBackToMenuOnAppear = true
        } else {
            convertAndForwardCNContacts(cnContacts)
            navigateBackToMenuOnAppear = true
        }
    }
    
    fileprivate func convertAndForwardCNContact(_ cnContact: CNContact) {
        let contactWrapper
            = contactCNConverter.convertCNContactWrapped(cnContact)
        
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier:
                    ContactPickerWrapperViewController.toImagePreviewSegue,
                sender: contactWrapper
            )
        }
    }
    
    fileprivate func convertAndForwardCNContacts(_ cnContacts: [CNContact]) {
        let contactWrappers
            = contactCNConverter.convertCNContactsWrapped(cnContacts)
    }
    
    fileprivate func navigateBackToMenu() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - CNContactPickerDelegate

extension ContactPickerWrapperViewController: CNContactPickerDelegate {
    
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
                self.navigateBackToMenu()
            }
        )
    }
}
