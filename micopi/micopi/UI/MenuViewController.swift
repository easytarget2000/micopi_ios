import UIKit

class MenuViewController: UIViewController {
    
    fileprivate static let toContactPickerSegue
        = "MenuToContactPickerWrapperSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showContactListForGenerator()
    }

    fileprivate func showContactListForGenerator() {
        performSegue(
            withIdentifier: MenuViewController.toContactPickerSegue,
            sender: nil
        )
    }
}

