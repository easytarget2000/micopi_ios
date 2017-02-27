//
//  ImageFactory.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit.UIColor

class ImageFactory {
    
    fileprivate static let recommendedImageSize: CGFloat = 1600
    
    fileprivate let contact: MiContact
    
    fileprivate let imageSize: CGFloat
    
    convenience init(contact: MiContact) {
        self.init(contact: contact, imageSize: ImageFactory.recommendedImageSize)
    }
    
    init(contact: MiContact, imageSize: CGFloat) {
        self.contact = contact
        self.imageSize = imageSize
    }
    
    weak var context: CGContext?
    
    var rgb = CGColorSpaceCreateDeviceRGB()
    
    func generateImage(_ completionHandler: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global().async {
            // Background thread
            
            let generatedImage = self.generateInThread()
            
            DispatchQueue.main.async(execute: {
                completionHandler(generatedImage)
            })
        }
        
    }
    
    fileprivate func generateInThread() -> UIImage {
        let contextSize = CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize))
        UIGraphicsBeginImageContext(contextSize)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        // The background colour is based on the initial character of the Display Name.
        let displayedInitials = contact.initials
        
        let imageSizeHalf = Float(imageSize * 0.5)
        
        let mirrored = (Int(drand48() * 2) % 2) == 0
        
        let foliage = Foliage.init(imageSize: Float(imageSize), mirroredMode: mirrored)
        foliage.start(inCircleAtX: imageSizeHalf, atY: imageSizeHalf)
        
//        let color1 = UIColor.black.withAlphaComponent(0.2).cgColor
        let alpha: CGFloat = mirrored ? 0.4 : 0.2
        
        let color1 = ColorPalette.randomColor(withAlpha: alpha).cgColor
        let color2 = ColorPalette.randomColor(withAlpha: alpha).cgColor
        
        while foliage.updateAndDraw(
            inContext: context,
            withColor1: color1,
            color2: color2
        ) {}
        
        if !displayedInitials.isEmpty {
            //            CGContextSaveGState(context);
            //            [myLayer renderInContext:context];
            //            CGContextRestoreGState(context);
            
            //            context.setBlendMode(.clear)
            
            paintInitials(displayedInitials)
            //            context.setBlendMode(.normal)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
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
