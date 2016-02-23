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
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        generateImage()
    }
    
    private func generateImage() {
        if let c = contact {
            let factory = ImageFactory.init(contact: c, imageSize: ImageFactory.recommendedImageSize)
            previewImageView.image = factory.generateImage()
        }
    }
}
