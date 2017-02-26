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
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(SingleContactViewController.searchButtonTouched)
        )
        
        generateImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    fileprivate func generateImage() {
        contactNameLabel.text = contact!.displayName
        
        let viewWidth = previewImageView.frame.size.width
        
        let factory = ImageFactory.init(
            contact: contact!,
            imageSize: viewWidth > 600 ? viewWidth : 600
        )
        
        previewImageView.image = factory.generateImage()
    }
    
    // MARK: - Toolbar
    
    @IBAction func previousButtonTouched(_ sender: AnyObject) {
        if let c = contact {
            c.decreaseModification()
            generateImage()
        }
    }
    
    @IBAction func nextImageButtonTouched(_ sender: AnyObject) {
        if let c = contact {
            c.increaseModification()
            generateImage()
        }
    }
    
    @IBAction func assignButtonTouched(_ sender: AnyObject) {
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
            self.present(contactPicker, animated: true, completion: nil)
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        self.contact = MiContact(cn: contact)
        generateImage()
    }
    
}
