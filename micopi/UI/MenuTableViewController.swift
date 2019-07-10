import UIKit

class MenuTableViewController: UITableViewController {

    fileprivate static let toImagePreviewSegue
        = "MenuToImagePreviewSegue"
    fileprivate static let toBatchGeneratorSegue
        = "MenuToBatchGeneratorSegue"
    fileprivate static let contactPickerCellIdentifier
        = "ContactPickerCell"
    var contactPickerWrapper: ContactPickerWrapper = ContactPickerWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
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
}

// MARK: - ContactPickerWrapperDelegate

extension MenuTableViewController: ContactPickerWrapperDelegate {
    
    func contactPickerWrapperDidCancel(_ pickerWrapper: ContactPickerWrapper) {
        
    }
    
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contact: ContactHashWrapper
    ) {
        
    }
    
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contacts: [ContactHashWrapper]
    ) {
        
    }
    
}
