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
        
}
