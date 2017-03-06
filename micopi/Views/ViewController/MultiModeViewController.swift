//
//  MultiModeViewController.swift
//  micopi
//
//  Created by Michel Sievers on 06/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import ContactsUI

class MultiModeViewController: ContactAccessViewController {
    
    enum Mode {
        case assign
        case reset
    }
    
    var mode: Mode!
    
    fileprivate var contacts: [MiContact]!

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
            self.contacts.append(MiContact(cn: contact))
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
}
