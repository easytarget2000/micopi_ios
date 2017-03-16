//
//  ContactViewController.swift
//  micopi
//
//  Created by michel@easy-target.org on 2016-02-22.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class SingleContactViewController: ContactAccessViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var loadingOverlay: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var assignButton: UIBarButtonItem!
        
    var contact: MiContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Search", comment: "Select Contact"),
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(SingleContactViewController.openContactPicker)
        )
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = ColorPalette.backgroundGradient
        loadingOverlay.layer.insertSublayer(gradient, at: 0)
        
        messageLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        setLoadingOverlayHidden(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    fileprivate func generateImage() {
        showLoadingOverlay()
        
        contactNameLabel.text = contact!.displayName
        
        let viewWidth = previewImageView.frame.size.width
        
        let factory = ImageFactory.init(
            contact: contact!,
            imageSize: viewWidth > 600 ? viewWidth : 600
        )
        
        factory.generateImage {
            (generatedImage) in
            
            self.previewImageView.image = generatedImage
            self.hideLoadingOverlay()
        }
        
    }
    
    fileprivate func showLoadingOverlay() {
        showLoadingOverlay(
            withMessage: "Please wait."
        )
    }
    
    fileprivate func showLoadingOverlay(withMessage message: String) {
//        loadingOverlay.backgroundColor = ColorPalette.randomColor(withAlpha: 1)
        
        setLoadingOverlayHidden(false)
        
        loadingOverlay.alpha = 1
        
        messageLabel.text = message
    }
    
    fileprivate func hideLoadingOverlay() {
        UIView.animate(
            withDuration: 1,
            animations: {
                self.loadingOverlay.alpha = 0
            },
            completion: {
                (_) in
                self.setLoadingOverlayHidden(true)
            }
        )
    }
    
    fileprivate func hideLoadingOverlayDelayed() {
        UIView.animate(
            withDuration: 2,
            delay: 2,
            animations: {
                self.loadingOverlay.alpha = 0
            },
            completion: {
                (_) in
                self.setLoadingOverlayHidden(true)
            }
        )
    }
    
    fileprivate func setLoadingOverlayHidden(_ hidden: Bool) {
        self.loadingOverlay.isHidden = hidden
        
        let uiEnabled = hidden
        
        view.isUserInteractionEnabled = uiEnabled
        
        navigationItem.rightBarButtonItem?.isEnabled = uiEnabled
        refreshButton.isEnabled = uiEnabled
        assignButton.isEnabled = uiEnabled
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
            if DefaultsCoordinator.askBeforeOverwrite(), let _ = self.contact!.cn.imageData {
                self.present(overwriteAlertForContact: self.contact!, positiveHandler: {
                        (_) in
                        self.assignImage()
                    }
                )
            } else {
                self.assignImage()
            }
        })
    }
    
    fileprivate func assignImage() {
        let contact = self.contact!
        
        let didAssign = ContactPictureWriter.assign(
            self.previewImageView.image!,
            toContact: contact
        )
        
        let message: String
        if didAssign {
            message = String(
                format: "Assigned the image to %@.",
//                format: NSLocalizedString("single_did_assign", comment: "Did assign to %s"),
                contact.displayName
            )
        } else {
            message = String(
                format: "There was an error assigning the image to %@.",
//                format: NSLocalizedString("single_error_assign", comment: "Did not assign to %s"),
                contact.displayName
            )
        }
        
        showLoadingOverlay(withMessage: message)
        hideLoadingOverlayDelayed()
    }
    
    // MARK: - Contact Picker
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        self.contact = MiContact(cn: contact)
        generateImage()
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        if self.contact == nil {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
