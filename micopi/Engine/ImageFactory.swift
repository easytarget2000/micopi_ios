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
    
    fileprivate var stopped = false
    
    convenience init(contact: MiContact) {
        self.init(contact: contact, imageSize: ImageFactory.recommendedImageSize)
    }
    
    init(contact: MiContact, imageSize: CGFloat) {
        self.contact = contact
        self.imageSize = imageSize
    }
    
    weak var context: CGContext?
    
    var rgb = CGColorSpaceCreateDeviceRGB()
    
    func generateImage(_ completionHandler: @escaping (UIImage?) -> ()) {
        
        DispatchQueue.global().async {
            // Background thread
            
            let generatedImage = self.generateInThread()
            
            DispatchQueue.main.async(execute: {
                completionHandler(generatedImage)
            })
        }
        
    }
    
    func generateInThread() -> UIImage? {
        stopped = false
        
        let imageSize = Float(self.imageSize)

        let contextSize = CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize))
        UIGraphicsBeginImageContext(contextSize)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: self.imageSize, height: self.imageSize))
        
        // The background colour is based on the initial character of the Display Name.
        let displayedInitials = contact.initials
        
        let numberOfShapes = Random.i(largerThan: 2, smallerThan: 6)
        let mirrored = Random.b(withChance: 0.5)
//        let alpha: CGFloat = (mirrored ? 0.2 : 0.1) / CGFloat(numberOfShapes)
        let alpha = Random.cgF(greater: 0.05, smaller: 0.33)
        let mutableColor1 = Random.b(withChance: 0.2)
        let mutableColor2 = Random.b(withChance: 0.2)
        
        for i in 0 ..< numberOfShapes {
            if stopped {
                UIGraphicsEndImageContext()
                return nil
            }
            
            let foliage = Foliage.init(imageSize: Float(imageSize), mirroredMode: mirrored)
            let foliageX: Float
            let foliageY: Float
            if i == 0 {
                foliageX = Random.f(largerThan: imageSize * 0.4, smallerThan: imageSize * 0.6)
                foliageY = Random.f(largerThan: imageSize * 0.4, smallerThan: imageSize * 0.6)
            } else {
                foliageX = Random.f(largerThan: imageSize * 0.1, smallerThan: imageSize * 0.9)
                foliageY = Random.f(largerThan: imageSize * 0.1, smallerThan: imageSize * 0.9)
            }
            
//            foliage.start(inCircleAtX: foliageX, atY: foliageY)
            if Random.b(withChance: 0.5) {
                foliage.start(inCircleAtX: foliageX, atY: foliageY)
            } else {
                foliage.start(inPolygonAroundX: foliageX, y: foliageY)
            }
        
            var color1 = ColorPalette.randomColor(withAlpha: alpha).cgColor
            var color2 = ColorPalette.randomColor(withAlpha: alpha).cgColor
            
            while foliage.updateAndDraw(
                inContext: context,
                withColor1: color1,
                color2: color2
            ) {
                if mutableColor1 {
                    color1 = ColorPalette.randomColor(withAlpha: alpha).cgColor
                }
                if mutableColor2 {
                    color2 = ColorPalette.randomColor(withAlpha: alpha).cgColor
                }
                
                if stopped {
                    UIGraphicsEndImageContext()
                    return nil
                }
            }
        }
        
//        let color1 = UIColor.black.withAlphaComponent(0.2).cgColor
        
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
        
        if stopped {
            return nil
        }
        
        return newImage
    }
    
    func stop() {
        stopped = true
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


// MARK: - Character to Int Extension

extension Character {
    
    func intValue() -> Int {
        for s in String(self).unicodeScalars {
            return Int(s.value)
        }
        return 0
    }
}
