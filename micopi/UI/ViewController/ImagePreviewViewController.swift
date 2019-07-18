import UIKit

class ImagePreviewViewController: UITableViewController {
    
    // MARK: - Properties
    
    fileprivate static let imageSectionIndex = 0
    fileprivate static let saveActionSectionIndex = 1
    fileprivate static let imageSettingsSectionIndex = 2
    fileprivate static let assignActionRowIndex = 0
    fileprivate static let nextImageActionRowIndex = 0
    fileprivate static let previousImageActionRowIndex = 1
    var contactWrapper: ContactHashWrapper!
    
    // MARK: IB

    @IBOutlet var viewModel: ContactHashWrapperViewModel!
    @IBOutlet var assignConfirmationViewModel: ImageAssignConfirmationViewModel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    // MARK: - Implementations
    
    fileprivate func setupViewModel() {
        viewModel.displayName.bind = {
            [weak self] in
            $0
            self?.tableView?.reloadData()
        }
        viewModel.generatedImage.bind = {
            [weak self] in
            self?.previewImageView?.image = $0
        }
        viewModel.isGenerating.bind = {
            [weak self] in
            if $0 {
                self?.activityIndicatorView?.startAnimating()
            } else {
                self?.activityIndicatorView?.stopAnimating()
            }
        }
        viewModel.contactWrapper = contactWrapper
    }
    
    fileprivate func assignImageToContact() {
        let didAssign = viewModel.assignImageToContact()
        let confirmationAlert = assignConfirmationViewModel.alertForContact(
            contact: contactWrapper?.contact,
            success: didAssign
        )
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    fileprivate func generatePreviousImage() {
        viewModel.generatePreviousImage()
    }
    
    fileprivate func generateNextImage() {
        viewModel.generateNextImage()
    }
}

// MARK: - UITableViewDataSource

extension ImagePreviewViewController {
    
    override func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        guard section == ImagePreviewViewController.imageSectionIndex else {
            return nil
        }
        
        return viewModel.displayName.value
    }
}

// MARK: - UITableViewDelegate

extension ImagePreviewViewController {
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case ImagePreviewViewController.saveActionSectionIndex:
            assignImageToContact()
        case ImagePreviewViewController.imageSettingsSectionIndex:
            switch indexPath.row {
            case ImagePreviewViewController.nextImageActionRowIndex:
                generateNextImage()
            case ImagePreviewViewController.previousImageActionRowIndex:
                generatePreviousImage()
            default:
                break
            }
        default:
            break
        }
    }
}
