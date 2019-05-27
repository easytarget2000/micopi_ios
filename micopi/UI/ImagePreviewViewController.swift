import UIKit

class ImagePreviewViewController: UIViewController {
    
    var contactWrapper: ContactHashWrapper!
    var contactWriter: ContactWriter!
    fileprivate var contact: Contact! {
        get {
            return contactWrapper.contact
        }
    }
    fileprivate var generatedImage: UIImage? {
        didSet {
            
        }
    }

    @IBOutlet weak var contactFullNameLabel: UILabel!
    @IBAction func assignButtonTouched(_ sender: Any) {
        assignImageToContact()
    }
    @IBAction func previousImageButtonTouched(_ sender: Any) {
        generatePreviousImage()
    }
    @IBAction func nextImageButtonTouched(_ sender: Any) {
        generateNextImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateContactViews()
    }

    fileprivate func populateContactViews() {
        contactFullNameLabel.text = contact.fullName
    }
    
    fileprivate func assignImageToContact() {
        guard let generatedImage = generatedImage else {
            return
        }
        
        contactWriter.assignImage(generatedImage, toContact: contact)
    }
    
    fileprivate func generatePreviousImage() {
        
    }
    
    fileprivate func generateNextImage() {
        
    }
}
