import UIKit

class ImagePreviewViewController: UIViewController {
    
    // MARK: - Values
    
    var contactWrapper: ContactHashWrapper!
    
    // MARK: IB

    @IBOutlet var viewModel: ContactHashWrapperViewModel!
    @IBOutlet weak var previewImageView: UIImageView!
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
        populateContactViews()
    }
    
    // MARK: - Implementations

    fileprivate func populateContactViews() {
        viewModel.populateDisplayNameLabel(contactDisplayNameLabel)
        viewModel.generateImage(targetView: previewImageView)
    }
    
    fileprivate func assignImageToContact() {
        viewModel.assignImageToContact()
    }
    
    fileprivate func generatePreviousImage() {
        viewModel.generatePreviousImage(targetView: previewImageView)
    }
    
    fileprivate func generateNextImage() {
        viewModel.generatePreviousImage(targetView: previewImageView)
    }
}
