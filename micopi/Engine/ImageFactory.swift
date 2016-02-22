//
//  ImageFactory.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class ImageFactory {
    
    var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func generateImage() -> UIImage {
        
        let font = UIFont.systemFontOfSize(48)
        
        UIGraphicsBeginImageContext(CGSize.init(width: 1024, height: 1024))
        
        UIColor.redColor().set()
        
        if let characters = contact.displayName?.characters, let firstChar = characters.first {
            let string = "\(firstChar)" as String
            string.drawInRect(CGRectMake(256, 256, 256, 256), withAttributes: nil)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
            
        return newImage
    }
}