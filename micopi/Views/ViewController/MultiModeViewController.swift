//
//  MultiModeViewController.swift
//  micopi
//
//  Created by michel@easy-target.org on 2017-03-06.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import ContactsUI

class MultiModeViewController: ContactAccessViewController {
    
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    enum Mode {
        case assign
        case reset
    }
    
    var mode: Mode!
    
    fileprivate var contacts: [MiContact]?
    
    fileprivate var isProcessing = false
    
    fileprivate var stopped = false
    
    fileprivate var imageFactory: ImageFactory?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = ColorPalette.backgroundGradient
        view.layer.insertSublayer(gradient, at: 0)
    }

    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        guard contacts.count > 0 else {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        self.contacts = [MiContact]()
        for contact in contacts {
            self.contacts!.append(MiContact(cn: contact))
        }
        
        if mode == .assign {
            showAssignDialog()
        } else {
            showResetDialog()
        }
    }
    
    fileprivate func showAssignDialog() {
        
    }
    
    fileprivate func showResetDialog() {
        
    }
    
    @IBAction func onContinueButtonTouched(_ sender: Any) {
        startProcessing()
    }
    
    
    
    @IBAction func onBackButtonTouched(_ sender: Any) {
        if isProcessing {
            stopProcessing()
        } else {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func startProcessing() {
        
        guard !isProcessing else {
            NSLog("MultiModeViewController: startProcessing(): ERROR: Already processing!")
            return
        }
        
        stopped = false
        
        DispatchQueue.global().async {
            // Background thread
            
            self.isProcessing = true
            
            for contact in self.contacts! {
                if self.stopped {
                    self.isProcessing = false
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    self.informationLabel.text = "Generating image for \(contact.displayName)"
                })
                self.imageFactory = ImageFactory.init(contact: contact)
                
                if let image = self.imageFactory?.generateInThread() {
                    if self.stopped {
                        self.isProcessing = false
                        return
                    }
                    ContactPictureWriter.assign(image, toContact: contact)
                } else {
                    NSLog("MultiModeViewController: startProcessing(): WARNING: No image generated for \(contact).")
                }
            }
            
            self.isProcessing = false
            
        }
        
    }
    
    fileprivate func stopProcessing() -> Bool {
        imageFactory?.stop()
        stopped = true
        
        informationLabel.text = "Canceled."
        backButton.setTitle("Back", for: .normal)
    }
}
