//
//  WelcomeViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private static let toContactViewSegue = "welcomeToContactSegue"

    @IBAction func onSelectContactTouched(sender: AnyObject) {
        performSegueWithIdentifier(WelcomeViewController.toContactViewSegue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if WelcomeViewController.toContactViewSegue == segue,
            let viewController = segue.destinationViewController as? ContactViewController {
                
                let contact = Contact()
                contact.displayName = "T¨st Us¬r"
                contact.emailAddress = "¥ssnn@å˙©.com"
                contact.phoneNumber = "+65996484"
                
                viewController.contact = contact
        }
    }
    
}
