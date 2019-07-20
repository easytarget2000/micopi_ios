import StoreKit

class BatchGeneratorViewController: UITableViewController {
    
    // MARK: - Properties
    
    fileprivate static let statusMessageSectionIndex = 0
    fileprivate static let buttonSectionIndex = 1
    fileprivate static let numOfActivitiesToRatingAlert = 3
    var contactWrappers: [ContactHashWrapper]!
    fileprivate var activityCounter = 0
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
        viewModel.buttonColor.bind = {
            [weak self] in
            self?.buttonCellLabel?.textColor = $0
        }
        viewModel.contactWrappers = contactWrappers
    }
    
    fileprivate func handleButtonTouch() {
        viewModel.handleButtonTouch()
    }
    
    fileprivate func increaseActivityCounter() {
        activityCounter += 1
        if activityCounter
            >= BatchGeneratorViewController.numOfActivitiesToRatingAlert {
            requestStoreReview()
        }
    }
    
    fileprivate func requestStoreReview() {
        SKStoreReviewController.requestReview()
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
