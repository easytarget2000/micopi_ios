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
    
    fileprivate var currentContactIndex = 0
    
    fileprivate var isProcessing = false {
        didSet {
            DispatchQueue.global().async {
                if self.isProcessing {
                    self.backButton.setTitle("Cancel", for: .normal)
                } else {
                    self.backButton.setTitle("Back", for: .normal)
                }
            }
        }
    }
    
    fileprivate var stopped = false
    
    fileprivate var imageFactory: ImageFactory?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = ColorPalette.backgroundGradient
        view.layer.insertSublayer(gradient, at: 0)
        
        informationLabel.text = ""
        
        continueButton.layer.cornerRadius = 4
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.layer.borderWidth = 1
        continueButton.layer.masksToBounds = true
        continueButton.isHidden = true
        continueButton.isEnabled = false
        
//        backButton.layer.cornerRadius = 4
//        backButton.layer.borderColor = UIColor.white.cgColor
//        backButton.layer.borderWidth = 1
//        backButton.layer.masksToBounds = true
        backButton.isHidden = true
        backButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
            showAssignMessage()
        } else if mode == .reset {
            showResetMessage()
        }
        
        continueButton.isHidden = false
        continueButton.isEnabled = true
        
        backButton.isHidden = false
        backButton.isEnabled = true
    }
    
    override func showLoadingViews() {
        super.showLoadingViews()
        
        informationLabel.text = "Please wait."
        
        continueButton.isHidden = true
        continueButton.isEnabled = false
        backButton.isHidden = true
        continueButton.isEnabled = false
    }
    
    fileprivate func showAssignMessage() {
        let numberOfContacts = self.contacts!.count
        let imageNoun = numberOfContacts > 1 ? "images" : "image"
        informationLabel.text = "Please confirm that you would like to overwrite \(numberOfContacts) contact \(imageNoun)."
    }
    
    fileprivate func showResetMessage() {
        let numberOfContacts = self.contacts!.count
        let imageNoun = numberOfContacts > 1 ? "images" : "image"
        informationLabel.text = "Please confirm that you would like to delete \(numberOfContacts) contact \(imageNoun)."
    }
    
    @IBAction func onContinueButtonTouched(_ sender: Any) {
        if mode == .assign {
            startGeneratingAndAssigning()
        } else if mode == .reset {
            startResetting()
        }
    }
    
    @IBAction func onBackButtonTouched(_ sender: Any) {
        if isProcessing {
            stopProcessing()
        } else {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func startGeneratingAndAssigning() {
        
        guard !isProcessing else {
            NSLog("MultiModeViewController: startProcessing(): ERROR: Already processing!")
            return
        }
        
        stopped = false
        continueButton.isHidden = true
        continueButton.isEnabled = false
        informationLabel.text = ""
        
        currentContactIndex = 0
        
        DispatchQueue.global().async {
            self.continueProcessing()
        }
        
    }
    
    fileprivate func continueProcessing() {
        guard let contacts = self.contacts, self.currentContactIndex < contacts.count else {
                
            DispatchQueue.main.async(execute: {
                    self.isProcessing = false
                    self.showDoneMessage()
                }
            )
            return
        }
        
        if self.stopped {
            self.isProcessing = false
            return
        }
        
        isProcessing = true
        
        let contact = contacts[self.currentContactIndex]
        
        if DefaultsCoordinator.askBeforeOverwrite(), let _ = contact.cn.imageData {
            DispatchQueue.main.async(execute: {
            self.present(
                overwriteAlertForContact: contact,
                positiveHandler: {
                    (_) in
                    DispatchQueue.global().async {
                        self.generate(imageForContact: contact)
                        self.nextContact()
                    }
                },
                cancelHandler: {
                    (_) in
                    self.nextContact()
                }
            )
            })
        } else {
            self.generate(imageForContact: contact)
            self.nextContact()
        }
    }
    
    fileprivate func generate(imageForContact contact: MiContact) {
        
        DispatchQueue.main.async(execute: {
            self.informationLabel.text = "Generating image for \(contact.displayName)."
        })
        imageFactory = ImageFactory.init(contact: contact)
        
        if let image = imageFactory?.generateInThread() {
            if stopped {
                isProcessing = false
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.informationLabel.text = "Assigning new image to \(contact.displayName)."
            })
            
            let _ = ContactPictureWriter.assign(image, toContact: contact)
        } else {
            NSLog("MultiModeViewController: startProcessing(): WARNING: No image generated for \(contact).")
        }
    }
    
    fileprivate func nextContact() {
        currentContactIndex += 1
        continueProcessing()
    }
    
    fileprivate func startResetting() {
        guard !isProcessing else {
            NSLog("MultiModeViewController: startProcessing(): ERROR: Already processing!")
            return
        }
        
        stopped = false
        continueButton.isHidden = true
        continueButton.isEnabled = false
        backButton.setTitle("Back", for: .normal)

        DispatchQueue.global().async {
            // Background thread
            
            self.isProcessing = true
            
            for contact in self.contacts! {
                if self.stopped {
                    self.isProcessing = false
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    self.informationLabel.text = "Deleting image of \(contact.displayName)."
                })
                
                let _ = ContactPictureWriter.delete(imageOfContact: contact)
            }
            
            DispatchQueue.main.async(execute: {
                    self.isProcessing = false
                    self.showDoneMessage()
                }
            )
        }
    }
    
    fileprivate func showDoneMessage() {
        
        let actionVerb = mode == .reset ? "Deleted" : "Assigned"
        let imageNoun = contacts!.count > 1 ? "images" : "image"
        informationLabel.text = "\(actionVerb) \(contacts!.count) \(imageNoun)."
        
        contacts = nil

        continueButton.isHidden = true
        continueButton.isEnabled = false
        backButton.setTitle("Back", for: .normal)
    }
    
    fileprivate func stopProcessing() {
        imageFactory?.stop()
        stopped = true
        isProcessing = false
        
        informationLabel.text = "Canceled."
    }
}
