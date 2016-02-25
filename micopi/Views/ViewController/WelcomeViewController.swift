//
//  WelcomeViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class WelcomeViewController: ContactAccessViewController {
    
    private static let toContactViewSegue = "welcomeToContactSegue"
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = ColorCollection.backgroundGradientColors
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: Navigation

    @IBAction func onSelectContactTouched(sender: AnyObject) {
        AppDelegate.getAppDelegate().requestForAccess {
            () -> Void in
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.presentViewController(contactPicker, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if WelcomeViewController.toContactViewSegue == segue.identifier,
            let viewController = segue.destinationViewController as? SingleContactViewController,
            let contact = sender as? MiContact {
                
            viewController.contact = contact
        }
    }
    
    // MARK: - CNContactPickerDelegate
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        performSegueWithIdentifier(
            WelcomeViewController.toContactViewSegue,
            sender: MiContact(cn: contact)
        )
    }
}
