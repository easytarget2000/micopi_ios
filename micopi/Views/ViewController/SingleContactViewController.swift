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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    private func generateImage() {
        contactNameLabel.text = contact!.displayName
        
        let factory = ImageFactory.init(contact: contact!, imageSize: previewImageView.frame.size.width)
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
