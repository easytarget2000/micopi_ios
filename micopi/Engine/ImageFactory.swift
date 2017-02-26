//
//  ImageFactory.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class ImageFactory {
    
    static let recommendedImageSize: CGFloat = 1600
    
    let contact: MiContact
    
    let imageSize: CGFloat
    
    init(contact: MiContact, imageSize: CGFloat) {
        self.contact = contact
        self.imageSize = imageSize
    }
    
    weak var context: CGContext?
    
    var rgb = CGColorSpaceCreateDeviceRGB()
    
    func generateImage() -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageSize, height: imageSize))
        
        context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        // The background colour is based on the initial character of the Display Name.
        let displayedInitials = contact.initials
        
        if !displayedInitials.isEmpty {
            paintInitials(displayedInitials)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        context = nil
        
        return newImage!
    }
   
    // MARK: - Initials Circle
    
    fileprivate func paintInitials(_ initials: String!) {
        
        let attributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: imageSize * pow(0.66, CGFloat(initials.characters.count))),
//            NSFontAttributeName : UIFont.systemFontOfSize(12.0),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        let stringSize = initials.size(attributes: attributes)
        
        initials.draw(
            in: CGRect(
                x: (imageSize - stringSize.width) / 2,
                y: (imageSize - stringSize.height) / 2,
                width: stringSize.width,
                height: stringSize.height
            ),
            withAttributes: attributes
        )
    }
    
}

extension Character {
    
    func intValue() -> Int {
        for s in String(self).unicodeScalars {
            return Int(s.value)
        }
        return 0
    }
}
