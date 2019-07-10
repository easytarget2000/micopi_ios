import UIKit

class MenuTableViewController: UITableViewController {

    fileprivate static let toContactPickerSegue
        = "MenuToContactPickerWrapperSegue"
    fileprivate static let contactPickerCellIdentifier
        = "ContactPickerCell"

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
        performSegue(
            withIdentifier: MenuTableViewController.toContactPickerSegue,
            sender: nil
        )
    }
}
