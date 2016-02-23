//
//  WelcomeViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit
import ContactsUI

class WelcomeViewController: UIViewController, CNContactPickerDelegate {
    
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
    
    // MARK: Navigation

    @IBAction func onSelectContactTouched(sender: AnyObject) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if WelcomeViewController.toContactViewSegue == segue.identifier,
            let viewController = segue.destinationViewController as? ContactViewController,
            let contact = sender as? Contact {
                
            viewController.contact = contact
        }
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        performSegueWithIdentifier(
            WelcomeViewController.toContactViewSegue,
            sender: Contact(c: contact)
        )
    }
}
