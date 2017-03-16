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
        
        let fullRect = CGRect(x: 0, y: 0, width: self.imageSize, height: self.imageSize)
        
        var backgroundImage: UIImage?
        if DefaultsCoordinator.overdrawExistingImage(),
            let imageData = contact.cn.imageData,
            let image = UIImage(data: imageData) {
            
            image.draw(in: fullRect)
            backgroundImage = image
            
        } else {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(fullRect)
        }
        
        // The background colour is based on the initial character of the Display Name.
        let displayedInitials = contact.initials
        
        let numberOfShapes = Random.i(largerThan: 2, smallerThan: 7)
        let mirrored = Random.b(withChance: 0.5)
//        let alpha: CGFloat = (mirrored ? 0.2 : 0.1) / CGFloat(numberOfShapes)
        let alpha = (mirrored ? 2 : 1) * Random.cgF(greater: 0.05, smaller: 0.15)
        let mutableColor1 = backgroundImage == nil && Random.b(withChance: 0.2)
        let mutableColor2 = backgroundImage == nil  && Random.b(withChance: 0.2)
        
        for i in 0 ..< numberOfShapes {
            if stopped {
                UIGraphicsEndImageContext()
                return nil
            }
            
            let foliage = Foliage.init(imageSize: Float(imageSize), mirroredMode: mirrored)
            let foliageX: Float
            let foliageY: Float
            if i < 4 {
                foliageX = Random.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
                foliageY = Random.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
            } else {
                foliageX = Random.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
                foliageY = Random.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
            }
            
//            foliage.start(inCircleAtX: foliageX, atY: foliageY)
            if Random.b(withChance: 0.5) {
                foliage.start(inCircleAtX: foliageX, atY: foliageY)
            } else {
                foliage.start(inPolygonAroundX: foliageX, y: foliageY)
            }
        
            var color1: CGColor
            var color2: CGColor

            if let image = backgroundImage {
                color1 = image.get(cgColorAtX: Int(foliageX), y: Int(foliageY), alpha: 0.5)
                let color2X = foliageX < imageSize - 5 ? Int(foliageX + 5) : Int(foliageX + 5)
                let color2Y = foliageY < imageSize - 5 ? Int(foliageY + 5) : Int(foliageY + 5)
                color2 = image.get(cgColorAtX: color2X, y: color2Y, alpha: 0.5)
            } else {
                color1 = ColorPalette.randomColor(withAlpha: alpha).cgColor
                color2 = ColorPalette.randomColor(withAlpha: alpha).cgColor
            }
            
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
        
        if let initials = displayedInitials, !initials.isEmpty {
            paintInitials(initials)
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
        
        let fontSize = imageSize * pow(0.66, CGFloat(initials.characters.count))
        
        let attributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: fontSize),
//            NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)),
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


// MARK: - UIImage pixel color extension

extension UIImage {
    
    func get(cgColorAtX x: Int, y: Int, alpha: CGFloat = 1) -> CGColor {
        return get(colorAtX: x, y: y).withAlphaComponent(alpha).cgColor
    }
    
    func get(colorAtX x: Int, y: Int) -> UIColor {
        
        guard let cgImage = self.cgImage else {
            return UIColor.brown
        }
        
        guard let imageDataProvider = cgImage.dataProvider else {
            return UIColor.lightGray
        }
        
        guard let pixelData = imageDataProvider.data else {
            return UIColor.black
        }
        
        guard let data = CFDataGetBytePtr(pixelData) else {
            return UIColor.cyan
        }
        
        let index = Int(self.size.width) * y + x
        let expectedLengthA = Int(self.size.width * self.size.height)
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3*index])/255.0, green: CGFloat(data[3*index+1])/255.0, blue: CGFloat(data[3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4*index])/255.0, green: CGFloat(data[4*index+1])/255.0, blue: CGFloat(data[4*index+2])/255.0, alpha: CGFloat(data[4*index+3])/255.0)
        default:
            return UIColor.orange
        }
    }
}
