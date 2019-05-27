import UIKit

class ImagePreviewViewController: UIViewController {
    
    var contactWrapper: ContactHashWrapper!
    var contact: Contact! {
        get {
            return contactWrapper.contact
        }
    }

    @IBOutlet weak var contactFullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateContactViews()
    }

    fileprivate func populateContactViews() {
        contactFullNameLabel.text = contact.fullName
    }
    
}
