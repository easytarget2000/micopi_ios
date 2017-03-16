//
//  ContactAccessViewController.swift
//  Micopi
//
//  Created by michel@easy-target.org on 2016-02-25.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class ContactAccessViewController: UIViewController, CNContactPickerDelegate {
    
    var openContactPickerOnAppear = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if openContactPickerOnAppear {
            openContactPicker()
            openContactPickerOnAppear = false
        }
    }
    
    func openContactPicker() {
        AppDelegate.getAppDelegate().requestForAccess {
            () -> Void in
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.present(contactPicker, animated: true, completion: nil)
        }
        
    }
    
    func present(
        overwriteAlertForContact contact: MiContact,
        positiveHandler: ((UIAlertAction) -> Swift.Void)? = nil,
        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil
    ) {
        let alert = UIAlertController(
            title: contact.displayName,
            message: "This contact already has an image. Are you sure you would like to overwrite it? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        alert.addAction(cancelAction)
        
        let positiveAction = UIAlertAction(
            title: "Overwrite",
            style: .destructive,
            handler: positiveHandler
        )
        alert.addAction(positiveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
