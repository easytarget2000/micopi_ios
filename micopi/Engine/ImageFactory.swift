//
//  ImageFactory.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class ImageFactory {
    
    private static let imageSize: CGFloat = 1600
    
    var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    weak var context: CGContext?
    
    func generateImage() -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize.init(width: ImageFactory.imageSize, height: ImageFactory.imageSize))
        
        context = UIGraphicsGetCurrentContext()
        
        // The background color is based on the initial character of the Display Name.
        var displayedInitials = ""
        if let characters = contact.displayName?.characters, let firstChar = characters.first {
            CGContextSetFillColorWithColor(context, ColorCollection.color(firstChar.hashValue));
            displayedInitials = String(firstChar)
        } else {
            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);
        }
        CGContextFillRect(context, CGRectMake(0, 0, ImageFactory.imageSize, ImageFactory.imageSize));
        
        paintPixeMatrix()
        
        paintInitialsCircle(displayedInitials)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        context = nil
        
        return newImage
    }
    
    private func paintPixeMatrix() {
        
        let color1 = ColorCollection.color(contact.md5[0])
        NSLog("\(color1)")
        
//        final String md5String = contact.getMD5EncryptedString();
//        final int md5Length = md5String.length();
//        
//        final int color1 = ColorCollection.getColor(md5String.charAt(16));
//        final int color2 = Color.WHITE;
//        final int color3 = ColorCollection.getColor(md5String.charAt(17));
//        
//        int numOfSquares = NUM_OF_SQUARES;
//        if (contact.getNameWord(0).length() % 2 == 0) numOfSquares -= 1;
//        final float sideLength = painter.getImageSize() / numOfSquares;
//        
//        int md5Pos = 0;
//        for (int y = 0; y < numOfSquares; y++) {
//            for (int x = 0; x < numOfSquares; x++) {
//                md5Pos++;
//                if (md5Pos >= md5Length) md5Pos = 0;
//                final char md5Char = md5String.charAt(md5Pos);
//                
//                if (isOddParity(md5Char)) {
//                    painter.paintSquare(
//                        color1,
//                        255,        // Alpha
//                        x,
//                        y,
//                        sideLength
//                    );
//                    if (x == 0) {
//                        painter.paintSquare(
//                            color2,
//                            200 - md5Char,
//                            4,
//                            y,
//                            sideLength
//                        );
//                    }
//                    if (x % 2 == 1) {
//                        painter.paintSquare(
//                            color3,
//                            200 - md5Char,
//                            3,
//                            y,
//                            sideLength
//                        );
//                    }
//                }
//            }
//        }
    }
    
    private func paintInitialsCircle(initials: String) {
        if let firstChar = initials.characters.first {
            // Use Palette colour based on first character - 11,
            // so that background and circle colour are based on the initials but not the same.
            
            CGContextSetFillColorWithColor(
                context,
                ColorCollection.color(firstChar.hashValue - 11)
            );
            let radius = ImageFactory.imageSize * 0.8
            let circlePosition = (ImageFactory.imageSize - radius) / 2
            CGContextFillEllipseInRect(
                context,
                CGRectMake(
                    circlePosition,
                    circlePosition,
                    radius,
                    radius
                )
            )
            
            let string = "\(firstChar)" as NSString
            
            let attributes = [
                NSFontAttributeName : UIFont.systemFontOfSize(ImageFactory.imageSize * 0.75),
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            
            let stringSize = string.sizeWithAttributes(attributes)
            
            string.drawInRect(
                CGRectMake(
                    (ImageFactory.imageSize - stringSize.width) / 2,
                    (ImageFactory.imageSize - stringSize.height) / 2,
                    stringSize.width,
                    stringSize.height
                ),
                withAttributes: attributes
            )
        }
    }
    
}