//
//  WelcomeViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class WelcomeViewController: ContactAccessViewController {
    
    @IBOutlet weak var pickerButton: UIButton!
    
    fileprivate static let toContactViewSegue = "welcomeToContactSegue"
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = ColorCollection.backgroundGradientColors
//        view.layer.insertSublayer(gradient, at: 0)
        
        pickerButton.layer.cornerRadius = 4
        pickerButton.layer.borderColor = UIColor.white.cgColor
        pickerButton.layer.borderWidth = 1
        pickerButton.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Navigation

    @IBAction func onSelectContactTouched(_ sender: AnyObject) {
        AppDelegate.getAppDelegate().requestForAccess {
            () -> Void in
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.present(contactPicker, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if WelcomeViewController.toContactViewSegue == segue.identifier,
            let viewController = segue.destination as? SingleContactViewController,
            let contact = sender as? MiContact {
                
            viewController.contact = contact
        }
    }
    
    // MARK: - CNContactPickerDelegate
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        performSegue(
            withIdentifier: WelcomeViewController.toContactViewSegue,
            sender: MiContact(cn: contact)
        )
    }
}
