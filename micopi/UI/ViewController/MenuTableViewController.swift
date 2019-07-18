import UIKit

class MenuTableViewController: UITableViewController {

    fileprivate static let toImagePreviewSegue
        = "MenuToImagePreviewSegue"
    fileprivate static let toBatchGeneratorSegue
        = "MenuToBatchGeneratorSegue"
    fileprivate static let contactPickerCellIdentifier
        = "ContactPickerCell"
    var contactPickerWrapper: ContactPickerWrapper = ContactPickerWrapper()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagePreviewViewController
            = segue.destination as? ImagePreviewViewController {
            
            let contactWrapper = sender as! ContactHashWrapper
            imagePreviewViewController.contactWrapper = contactWrapper
        } else if let batchGeneratorViewController
            = segue.destination as? BatchGeneratorViewController {
            let contactWrappers = sender as! [ContactHashWrapper]
            batchGeneratorViewController.contactWrappers = contactWrappers
        }
    }

    // MARK: - UITableViewDelegate

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        showContactPickerViewController()
    }
    
    
    // MARK: - Implementations
    
    fileprivate func showContactPickerViewController() {
        contactPickerWrapper.delegate = self
        contactPickerWrapper.showContactPicker(sourceViewController: self)
    }
    
    fileprivate func showImagePreviewViewController(
        contactWrapper: ContactHashWrapper
    ) {
        performSegue(
            withIdentifier: MenuTableViewController.toImagePreviewSegue,
            sender: contactWrapper
        )
    }
    
    fileprivate func showBatchGeneratorViewController(
        contactWrappers: [ContactHashWrapper]
    ) {
        performSegue(
            withIdentifier: MenuTableViewController.toBatchGeneratorSegue,
            sender: contactWrappers
        )
    }
}

// MARK: - ContactPickerWrapperDelegate

extension MenuTableViewController: ContactPickerWrapperDelegate {
    
    func contactPickerWrapperDidCancel(_ pickerWrapper: ContactPickerWrapper) {
        
    }
    
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contactWrapper: ContactHashWrapper
    ) {
        showImagePreviewViewController(contactWrapper: contactWrapper)
    }
    
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contactWrappers: [ContactHashWrapper]
    ) {
        showBatchGeneratorViewController(contactWrappers: contactWrappers)
    }
    
}
