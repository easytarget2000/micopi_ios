//
//  ContactViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class SingleContactViewController: ContactAccessViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    var contact: MiContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Search", comment: "Select Contact"),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "searchButtonTouched"
        )
        
        generateImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.toolbarHidden = true
    }
    
    private func generateImage() {
        guard let c = contact else {
            NSLog("FAILURE: ContactViewController: Without Contact.")
            navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        if let displayName = c.displayName {
            contactNameLabel.text = displayName
        } else if let email = c.emailAddress {
            contactNameLabel.text = email
        } else if let phoneNumber = c.phoneNumber {
            contactNameLabel.text = phoneNumber
        } else {
            NSLog("FAILURE: ContactViewController: \(c) without data.")
            navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        let factory = ImageFactory.init(contact: c, imageSize: previewImageView.frame.size.width)
        previewImageView.image = factory.generateImage()
    }
    
    // MARK: - Toolbar
    
    @IBAction func previousButtonTouched(sender: AnyObject) {
        if let c = contact {
            c.decreaseModification()
            generateImage()
        }
    }
    
    @IBAction func nextImageButtonTouched(sender: AnyObject) {
        if let c = contact {
            c.increaseModification()
            generateImage()
        }
    }
    
    @IBAction func assignButtonTouched(sender: AnyObject) {
        AppDelegate.getAppDelegate().requestForAccess({
            () -> Void in
                ContactPictureWriter.assign(self.contact!)
            }
        )
    }
    
    // MARK: - Contact Picker
    
    func searchButtonTouched() {
        AppDelegate.getAppDelegate().requestForAccess {
            () -> Void in
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.presentViewController(contactPicker, animated: true, completion: nil)
        }
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        self.contact = MiContact(cn: contact)
        generateImage()
    }
    
}
