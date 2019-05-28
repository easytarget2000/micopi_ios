import UIKit

class ImagePreviewViewController: UIViewController {
    
    var contactWrapper: ContactHashWrapper!
    var contactImageEngine: ContactImageEngine = ContactImageEngine()
    var contactWriter: ContactWriter = ContactWriter()
    fileprivate var contact: Contact! {
        get {
            return contactWrapper.contact
        }
    }
    fileprivate var generatedImage: UIImage? {
        didSet {
            previewImageView.image = generatedImage
        }
    }

    @IBOutlet weak var previewImageView: UIImageView!
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
        generateImage()
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
        contactWrapper.decreaseModifier()
        generateImage()
    }
    
    fileprivate func generateNextImage() {
        contactWrapper.increaseModifier()
        generateImage()
    }
    
    fileprivate func generateImage() {
        contactImageEngine.generateImageForContactAsync(
            contactWrapper: contactWrapper,
            completionHandler: {
                    (generatedImage) in
                    self.generatedImage = generatedImage
                }
        )
    }
}
