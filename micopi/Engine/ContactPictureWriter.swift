//
//  ContactPictureWriter.swift
//  Micopi
//
//  Created by Michel on 25/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class ContactPictureWriter {
    
    static func assign(_ contact: MiContact) -> Bool {
        let mutant = contact.cn.mutableCopy() as! CNMutableContact
        
        let factory = ImageFactory.init(contact: contact)
        
        let newImageData = UIImagePNGRepresentation(factory.generateImage())
        
        mutant.imageData = newImageData
        
        do {
            let saveRequest = CNSaveRequest()
            
            saveRequest.update(mutant)
            try AppDelegate.getAppDelegate().contactStore.execute(saveRequest)
            
            return true
        }
        catch {
            return false
        }
        
    }
}
