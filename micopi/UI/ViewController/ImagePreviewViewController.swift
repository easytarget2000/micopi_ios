import UIKit

class ImagePreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var contactWrapper: ContactHashWrapper!
    
    // MARK: IB

    @IBOutlet var viewModel: ContactHashWrapperViewModel!
    @IBOutlet var assignConfirmationViewModel: ImageAssignConfirmationViewModel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var contactDisplayNameLabel: UILabel!
    @IBAction func assignButtonTouched(_ sender: Any) {
        assignImageToContact()
    }
    @IBAction func previousImageButtonTouched(_ sender: Any) {
        generatePreviousImage()
    }
    @IBAction func nextImageButtonTouched(_ sender: Any) {
        generateNextImage()
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showBottomBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBottomBar()
    }
    
    // MARK: - Implementations
    
    fileprivate func setupViewModel() {
        viewModel.displayName.bind = {
            [weak self] in
            self?.contactDisplayNameLabel.text = $0
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
    
    fileprivate func showBottomBar() {
        navigationController?.isToolbarHidden = false
    }
    
    fileprivate func hideBottomBar() {
        navigationController?.isToolbarHidden = true
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
