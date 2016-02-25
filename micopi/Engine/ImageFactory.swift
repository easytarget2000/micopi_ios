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
    
    let contact: Contact
    
    let imageSize: CGFloat
    
    init(contact: Contact, imageSize: CGFloat) {
        self.contact = contact
        self.imageSize = imageSize
    }
    
    weak var context: CGContext?
    
    func generateImage() -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageSize, height: imageSize))
        
        context = UIGraphicsGetCurrentContext()
        
        // The background colour is based on the initial character of the Display Name.
        var displayedInitials = ""
        if let characters = contact.displayName?.characters, let firstChar = characters.first {
//            CGContextSetFillColorWithColor(context, ColorCollection.color(firstChar.hashValue).CGColor);
            displayedInitials = String(firstChar)
        } else {
//            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);
        }
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);

        CGContextFillRect(context, CGRectMake(0, 0, imageSize, imageSize));
        
        paintPixeMatrix()
        
        paintInitialsCircle(displayedInitials)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        context = nil
        
        return newImage
    }
    
    private func paintPixeMatrix() {
        
//        let color1 = ColorCollection.color(contact.md5[0])
        let color2 = ColorCollection.color(contact.md5[1])
        let color3 = ColorCollection.color(contact.md5[2])
        
//        let numberOfSquares = (contact.md5[2] % 6) + 4
        let numberOfSquares = 9
        
        let sideLength = imageSize / CGFloat(numberOfSquares)
        
        var md5Index = 2
        for y in 0 ..< numberOfSquares {
            for x in 0 ..< numberOfSquares {
                
                if ++md5Index >= 15 {
                    md5Index = 0
                }
                
                if ImageFactory.isOddParity(contact.md5[md5Index]) {
//                    paintPixelSquare(
//                        color1,
//                        alpha: 50,
//                        x: x,
//                        y: y,
//                        sideLength: sideLength
//                    )
                    
                    if x % 3 == 0 {
                        paintPixelSquare(
                            color2,
                            alpha: 155 - contact.md5[md5Index] % 100,
                            x: 4,
                            y: y,
                            sideLength: sideLength
                        )
                    }
                    if x % 2 == 0 {
                        paintPixelSquare(
                            color3,
                            alpha: 155 - contact.md5[md5Index] % 100,
                            x: 3,
                            y: y,
                            sideLength: sideLength
                        )
                    }
                }
            }
        }
    }
    
    private static func isOddParity(value: Int) -> Bool {
        var bb = value;
        var bitCount = 0;
        
        for _ in 0 ..< 16 {
            if (bb & 1) != 0 {
                bitCount++
            }
            bb >>= 1
        }
        
        return (bitCount & 1) != 0;
    }
    
    private func paintPixelSquare(
        color: UIColor,
        alpha: Int,
        x: Int,
        y: Int,
        sideLength: CGFloat
    ) {
        let offsetX = CGFloat(x) * sideLength
        let offsetY = CGFloat(y) * sideLength
        
        if (alpha > 0 && alpha < 255) {
            let percentageAlpha = CGFloat(alpha) / 255
            CGContextSetFillColorWithColor(
                context,
                color.colorWithAlphaComponent(percentageAlpha).CGColor
            );
        } else {
            CGContextSetFillColorWithColor(context, color.CGColor);
        }
        
        CGContextFillRect(context, CGRectMake(offsetX, offsetY, sideLength, sideLength));
    }
    
    // MARK: - Plates
    
    private func paintPlates() {
        var angleOffset = CGFloat(0)
        
        var width = (CGFloat(contact.md5[7] * contact.md5[8]) / imageSize) * (imageSize * 1.2)
        
        let smallestWidth = CGFloat(imageSize / 300) * CGFloat(contact.md5[9])

        var numberOfShapes = 3
        if let displayName = contact.displayName {
            numberOfShapes = displayName.characters.count
            if numberOfShapes < 3 {
                numberOfShapes = 3
            } else if numberOfShapes > 9 {
                numberOfShapes = 10
            }
        }
        
        let paintPolygon: Bool
        var numberOfEdges = 0
        
        if (contact.md5[10] % 4) > 0 {
            paintPolygon = true
            if let firstWord = contact.givenName {
                numberOfEdges = firstWord.characters.count
            } else if let nick = contact.nickname {
                numberOfEdges = nick.characters.count
            }
            
            if numberOfEdges < 3 {
                numberOfEdges = 3
            } else if numberOfEdges > 10 {
                numberOfEdges = 10
            }
        } else {
            paintPolygon = false
        }
        
        let extraDividend = CGFloat(contact.md5[11])
        
        var x = CGFloat(imageSize / 2)
        var y = x
        var md5Index = 0
        var movement: Int
        var floatMovement: CGFloat
        
        let alpha = CGFloat(0.7)
        
        for i in 0 ..< numberOfShapes{
            if ++md5Index > 15 {
                md5Index = 0
            }
            
            movement = contact.md5[md5Index] + i * 3
            floatMovement = CGFloat(movement)
            
            switch movement % 6 {
            case 0:
                x += floatMovement
                y -= floatMovement * 2
            case 1:
                x -= floatMovement * 2
                y += floatMovement
            case 2:
                x += floatMovement * 2
            case 3:
                y += floatMovement * 3
            case 4:
                x -= floatMovement * 2
                y -= floatMovement
            default:
                x -= floatMovement
                y -= floatMovement * 2
            }
            
            if paintPolygon {
                if numberOfEdges == 4 && movement % 3 == 0 {
                    paintRoundedSquare(
                        ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                        x: x,
                        y: y,
                        width: width
                    )
                } else {
                    angleOffset += extraDividend / floatMovement
                    
                    self.paintPolygon(
                        ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                        angleOffset: angleOffset,
                        numberOfEdges: numberOfEdges,
                        x: x,
                        y: y,
                        width: width
                    )
                }
            } else {
                paintCircle(
                    ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                    x: x,
                    y: y,
                    radius: width
                )
            }
            
            if width < smallestWidth {
                width *= 1.3
            } else {
                width *= 0.6
            }
        }
    }
    
    private func paintRoundedSquare(color: CGColor, x: CGFloat, y: CGFloat, width: CGFloat) {
        
    }
    
    private func paintPolygon(color: CGColor, angleOffset: CGFloat, numberOfEdges: Int, x: CGFloat, y: CGFloat, width: CGFloat) {
        
    }
    
    private func paintCircle(color: CGColor, x: CGFloat, y: CGFloat, radius: CGFloat) {
        
    }
    // MARK: - Initials Circle
    
    private func paintInitialsCircle(initials: String) {
        if let firstChar = initials.characters.first {
            // Use Palette colour based on first character minus specific values,
            // so that background and circle colour are based on the initials but not the same.
            
            let radius = imageSize * 0.4

            if contact.md5[7] % 3 == 0 {
                let diameter = radius * 2
                let circlePosition = (imageSize - diameter) / 2
                CGContextSetFillColorWithColor(
                    context,
                    ColorCollection.color(firstChar.hashValue - 11).colorWithAlphaComponent(0.3).CGColor
                );
                
                CGContextFillEllipseInRect(
                    context,
                    CGRectMake(
                        circlePosition,
                        circlePosition,
                        diameter,
                        diameter
                    )
                )
            }
            
            let thickness = CGFloat(imageSize) / 50
            
            let startAngleOffset = Double(contact.md5[5] % 5)
            let endAngleOffset = Double(contact.md5[6] % 4) - 7.0
            
            CGContextAddArc(
                context,
                imageSize / 2,
                imageSize / 2,
                radius,
                CGFloat(-M_PI / (4.0 + startAngleOffset)),
                CGFloat(-11.0 * M_PI / (4.0 + endAngleOffset)),
                1
            );
            
            CGContextSetLineWidth(context, thickness);
            CGContextSetLineCap(context, CGLineCap.Round);
            // Then we can ask Core Graphics to replace the path with a stroked version:
            CGContextReplacePathWithStrokedPath(context);
            
            CGContextSetShadowWithColor(
                context,
                CGSizeMake(0, thickness / 2),
                thickness / 2,
                UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
            )
            
            CGContextBeginTransparencyLayer(context, nil)
            
            let rgb = CGColorSpaceCreateDeviceRGB()
            let gradientColors = [
                ColorCollection.color(firstChar.hashValue - 4).CGColor,
                ColorCollection.color(contact.md5[4]).colorWithAlphaComponent(0.2).CGColor
            ]
            let gradient = CGGradientCreateWithColors(
                rgb,
                gradientColors,
                [0.0, 1.0]
            )
            
            // We also need to figure out a start point and an end point for the gradient.
            // We'll use the path bounding box:
            let bbox = CGContextGetPathBoundingBox(context);
            let start = bbox.origin;
            let end = CGPointMake(CGRectGetMaxX(bbox), CGRectGetMaxY(bbox));
            
            CGContextClip(context)
            
            CGContextDrawLinearGradient(context, gradient, start, end, CGGradientDrawingOptions(rawValue: 0))
            
            CGContextEndTransparencyLayer(context)
            
            let string = "\(firstChar)" as NSString
            
            let attributes = [
                NSFontAttributeName : UIFont.systemFontOfSize(imageSize * 0.75),
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            
            let stringSize = string.sizeWithAttributes(attributes)
            
            string.drawInRect(
                CGRectMake(
                    (imageSize - stringSize.width) / 2,
                    (imageSize - stringSize.height) / 2,
                    stringSize.width,
                    stringSize.height
                ),
                withAttributes: attributes
            )
        }
    }
    
}