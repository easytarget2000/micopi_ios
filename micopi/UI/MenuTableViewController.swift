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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MenuTableViewController.contactPickerCellIdentifier,
            for: indexPath
        )
        
        return populateContactPickerCell(cell)
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        showContactPickerViewController()
    }
    
    // MARK: - Implementations
    
    fileprivate func populateContactPickerCell(
        _ cell: UITableViewCell
    ) -> UITableViewCell {
        cell.textLabel?.text = "Select Contact DEBUG"
        cell.detailTextLabel?.text = "..."
        return cell
    }
    
    fileprivate func showContactPickerViewController() {
        performSegue(
            withIdentifier: MenuTableViewController.toContactPickerSegue,
            sender: nil
        )
    }
}
