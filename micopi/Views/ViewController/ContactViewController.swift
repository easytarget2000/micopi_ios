//
//  ContactViewController.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        generateImage()
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
        
        let factory = ImageFactory.init(contact: c, imageSize: ImageFactory.recommendedImageSize)
        previewImageView.image = factory.generateImage()
    }
}
