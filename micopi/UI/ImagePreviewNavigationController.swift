import UIKit

class ImagePreviewNavigationController: UINavigationController {

    var contactWrapper: ContactHashWrapper!
    var childViewController: ImagePreviewViewController! {
        get {
            return children.first as? ImagePreviewViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        forwardContactWrapper()
    }
    
    fileprivate func forwardContactWrapper() {
        childViewController.contactWrapper = contactWrapper
    }

}
