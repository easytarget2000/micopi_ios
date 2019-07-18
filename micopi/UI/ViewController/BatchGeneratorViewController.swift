import UIKit

class BatchGeneratorViewController: UITableViewController {
    
    // MARK: - Properties
    
    fileprivate static let statusMessageSectionIndex = 0
    fileprivate static let buttonSectionIndex = 1
    var contactWrappers: [ContactHashWrapper]!
    @IBOutlet var viewModel: BatchGeneratorViewModel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var buttonCellLabel: UILabel!
    
    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    // MARK: - Implementations
    
    fileprivate func setupViewModel() {
        viewModel.statusMessage.bind = {
            [weak self] in
            let _ = $0
            self?.tableView?.reloadData()
            self?.statusMessageLabel?.text = $0
        }
        viewModel.buttonTitle.bind = {
            [weak self] in
            self?.buttonCellLabel?.text = $0
        }
        viewModel.contactWrappers = contactWrappers
    }
    
    fileprivate func handleButtonTouch() {
        viewModel.handleButtonTouch()
    }
}

// MARK: - UITableViewDataSource

extension BatchGeneratorViewController {
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return nil
//        return viewModel.statusMessage.value
    }
}

// MARK: - UITableViewDelegate

extension BatchGeneratorViewController {
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section
            == BatchGeneratorViewController.buttonSectionIndex else {
            return
        }
        
        handleButtonTouch()
    }
}
