//
//  ContactPictureWriter.swift
//  Micopi
//
//  Created by Michel on 25/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import ContactsUI

class ContactPictureWriter {
    
    static func assign(contact: MiContact) -> Bool {
        let mutant = contact.cn.mutableCopy() as! CNMutableContact
        
        let factory = ImageFactory.init(contact: contact, imageSize: ImageFactory.recommendedImageSize)
        
        let newImageData = UIImagePNGRepresentation(factory.generateImage())
        
        mutant.imageData = newImageData
        
        do {
            let saveRequest = CNSaveRequest()
            
            saveRequest.updateContact(mutant)
            try AppDelegate.getAppDelegate().contactStore.executeSaveRequest(saveRequest)
            
            return true
        }
        catch {
            return false
        }
        
    }
}
