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
        CGContextFillRect(context, CGRectMake(0, 0, imageSize, imageSize))
        
        
        // The background colour is based on the initial character of the Display Name.
        let displayedInitials: String
        let secondColor = ColorCollection.color(contact.md5[15])

        if let firstChars = contact.displayName?.characters, let firstChar = firstChars.first {
            
            if let secondChar = contact.cn.familyName.characters.first {
                displayedInitials = String(firstChar) + String(secondChar)
            } else if let secondChar = contact.cn.middleName.characters.first {
                displayedInitials = String(firstChar) + String(secondChar)
            } else {
                displayedInitials = String(firstChar)
            }
            
            let gradientColors = [
                ColorCollection.color(firstChar.intValue()).CGColor,
                secondColor.CGColor
            ]
            let backgroundGradient = CGGradientCreateWithColors(
                rgb,
                gradientColors,
                [0.0, 0.66]
            )
            
            CGContextDrawLinearGradient(
                context,
                backgroundGradient,
                CGPoint(x: imageSize / 2, y: 0),
                CGPoint(x: imageSize / 2, y: imageSize),
                CGGradientDrawingOptions(rawValue: 0)
            )
            
            
        } else {
            displayedInitials = ""
        }
        
//        paintPixelMatrix()
        
        paintPolkaDots()
        
        paintPlates()
        
        paintInitials(displayedInitials)
        
//        paintInitialsCircle(displayedInitials, fillColor: secondColor)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        context = nil
        
        return newImage
    }
    
    // MARK: - Tiny Polka
    
    private func paintPolkaDots() {
        
        let numberOfRows = 20 + contact.md5[12] % 40
        
        let distanceToCellCenter = imageSize / CGFloat(numberOfRows)
        let diameter = distanceToCellCenter * 0.66
        let alpha = (CGFloat(contact.md5[13] % 9) / 10) + 0.1
        let color = UIColor.whiteColor().colorWithAlphaComponent(alpha).CGColor
                
        var yOffset = CGFloat(0)
        
        for x in 0 ..< numberOfRows {
            for y in 0 ..< numberOfRows {
                paintCircle(
                    color,
                    x: CGFloat(x) * distanceToCellCenter,
                    y: CGFloat(y) * distanceToCellCenter + yOffset,
                    diameter: diameter
                )
            }
            if x % 2 == 0 {
                yOffset = distanceToCellCenter / 2
            } else {
                yOffset = 0
            }
        }
        
    }
    
    // MARK: - Pixel Matrix
    
    private func paintPixelMatrix() {
        
        let color1 = ColorCollection.color(contact.md5[0])
        let color2 = ColorCollection.color(contact.md5[1])
        
        let numberOfSquares = (contact.md5[2] % 10) + 15
        
        let sideLength = imageSize / CGFloat(numberOfSquares)
        
        let leftAligned = (contact.md5[2] % 2) == 0
        let topAligned = (contact.md5[3] % 2) == 0
        
        var md5Index = 3
        var md5Value : Int
        
        for y in 1 ..< numberOfSquares {
            for x in 1 ..< numberOfSquares {
                
                if md5Index > 15 {
                    md5Index = 0
                } else {
                    md5Index += 1
                }
                
                md5Value = contact.md5[md5Index]
                
                if ImageFactory.isOddParity(contact.md5[md5Index]) {
                        paintPixelSquare(
                            color1,
                            alpha: 255 - (md5Value % 100),
                            x: leftAligned ? (md5Value % y) : (numberOfSquares - (md5Value % y)),
                            y: topAligned ? (md5Value % x) : (numberOfSquares - (md5Value % x)),
                            sideLength: sideLength
                        )
                } else if (x % 2 == 0) {
                    paintPixelSquare(
                        color2,
                        alpha: 255 - (md5Value % 100),
                        x: leftAligned ? (md5Value % x) : (numberOfSquares - (md5Value % x)),
                        y: topAligned ? (md5Value % y) : (numberOfSquares - (md5Value % y)),
                        sideLength: sideLength
                    )
                }
            }
        }
    }
    
    private static func isOddParity(value: Int) -> Bool {
        var bb = value;
        var bitCount = 0;
        
        for _ in 0 ..< 16 {
            if (bb & 1) != 0 {
                bitCount += 1
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
        
        var width = CGFloat(contact.md5[0] + contact.md5[1]) + (imageSize * 0.37)
        let smallestWidth = width * 0.37

        let numberOfShapes = (contact.md5[1] % 2) + 2
        
        var numberOfEdges = 3
        if !contact.cn.nickname.isEmpty {
            numberOfEdges = contact.cn.nickname.characters.count
        } else if !contact.cn.givenName.isEmpty {
            numberOfEdges = contact.cn.givenName.characters.count
        }
        
        if numberOfEdges < 3 {
            numberOfEdges = 3
        } else if numberOfEdges > 10 {
            numberOfEdges = 10
        }
        
        let extraDividend = CGFloat(contact.md5[11])
        
        var x = CGFloat(imageSize / 3)
        var y = x
        var md5Index = 0
//        var movement: Int
//        var floatMovement: CGFloat
        
        let alpha: CGFloat
        if contact.md5[7] % 3 == 0 {
            alpha = 1.0
        } else {
            alpha = 0.5 + (CGFloat(contact.md5[8] % 10) / 5)
        }
        
        enableShadows()
        
        for i in 0 ..< numberOfShapes {
            if md5Index > 15 {
                md5Index = 0
            } else {
                md5Index += 1
            }
            
            let movement = contact.md5[md5Index] + i * 3
            let floatMovement = CGFloat(movement)
            
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
            
            if contact.md5[md5Index] % 4 != 0 {
                if numberOfEdges == 4 && movement % 3 == 0 {
                    paintRoundedSquare(
                        ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                        x: x,
                        y: y,
                        width: width
                    )
                } else {
                    angleOffset += extraDividend / floatMovement
                    
                    paintPolygon(
                        ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                        angleOffset: angleOffset,
                        numberOfEdges: numberOfEdges,
                        centerX: x,
                        centerY: y,
                        width: width
                    )
                }
            } else {
                paintCircle(
                    ColorCollection.color(contact.md5[md5Index], alpha: alpha).CGColor,
                    x: x,
                    y: y,
                    diameter: width
                )
            }
            
            if width < smallestWidth {
                width *= 2
            } else {
                width *= 0.66
            }
        }
    }
    
    private func paintRoundedSquare(color: CGColor, x: CGFloat, y: CGFloat, width: CGFloat) {
        let path = UIBezierPath(
            roundedRect: CGRectMake(x, y, width, width),
            cornerRadius: imageSize / 50
        )
        
        CGContextAddPath(context, path.CGPath)
        CGContextSetFillColorWithColor(context, color);
        CGContextFillPath(context)
    }
    
    let floatingDoublePi = CGFloat(M_PI * 2)
    
    private func paintPolygon(
        color: CGColor,
        angleOffset: CGFloat,
        numberOfEdges: Int,
        centerX: CGFloat,
        centerY: CGFloat,
        width: CGFloat
    ) {
        
        let floatingNumberOfEdges = CGFloat(numberOfEdges)
        
        let path = CGPathCreateMutable()
        for edge in 0 ..< numberOfEdges {
            let angle = floatingDoublePi * CGFloat(edge) / floatingNumberOfEdges
            
            let x = centerX + width * cos(angle + angleOffset)
            let y = centerY + width * sin(angle + angleOffset)
            if edge == 0 {
                CGPathMoveToPoint(path, nil, x, y)
            } else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        CGPathCloseSubpath(path)
        
        CGContextAddPath(context, path)
        CGContextSetFillColorWithColor(context, color);
        CGContextFillPath(context)
    }

    // MARK: - Initials Circle
    
    private func paintInitials(initials: String) {
        
        let attributes = [
            NSFontAttributeName : UIFont.systemFontOfSize(imageSize * pow(0.66, CGFloat(initials.characters.count))),
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let stringSize = initials.sizeWithAttributes(attributes)
        
        initials.drawInRect(
            CGRectMake(
                (imageSize - stringSize.width) / 2,
                (imageSize - stringSize.height) / 2,
                stringSize.width,
                stringSize.height
            ),
            withAttributes: attributes
        )
    }
    
    let paintArc = true
    
    private func paintInitialsCircle(fillColor: UIColor) {
        
        let radius = imageSize * 0.4
        
        let filledCircleMode = contact.md5[8] % 3
        if filledCircleMode != 0 {
            
            let adjustedFillColor: CGColor
            if (filledCircleMode == 1) {
                adjustedFillColor = fillColor.colorWithAlphaComponent(
                    (CGFloat(contact.md5[9] % 8) / CGFloat(10)) + 0.1
                ).CGColor
            } else {
                adjustedFillColor = fillColor.CGColor
            }
            
            let diameter = radius * 2
            let circlePosition = (imageSize - diameter) / 2
            paintCircle(
                adjustedFillColor,
                x: circlePosition,
                y: circlePosition,
                diameter: diameter
            )
        }

        if paintArc {
            paintInitialsArc(radius)
        }

    }
    
    private func paintInitialsArc(radius: CGFloat) {
        let thickness = CGFloat(imageSize) / 50
        
        let startAngleOffset = Double(contact.md5[7] % 5)
        let endAngleOffset = Double(contact.md5[6] % 4) - 7.0
        
        CGContextAddArc(
            context,
            imageSize / 2,
            imageSize / 2,
            radius,
            CGFloat(-M_PI / 4.0),
            CGFloat(-11.0 * M_PI / 4.0 ),
            1
        );
        
        CGContextSetLineWidth(context, thickness);
        CGContextSetLineCap(context, CGLineCap.Round);
        // Then we can ask Core Graphics to replace the path with a stroked version:
        CGContextReplacePathWithStrokedPath(context);
        
//        enableShadows()
        
        CGContextBeginTransparencyLayer(context, nil)
        
        let gradientColors = [
            ColorCollection.color(contact.md5[15]).CGColor,
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
    }
    
    // MARK: - Frequently Used Shapes
    
    private func paintCircle(color: CGColor, x: CGFloat, y: CGFloat, diameter: CGFloat) {
        CGContextSetFillColorWithColor(context, color);
        
        CGContextFillEllipseInRect(
            context,
            CGRectMake(
                x,
                y,
                diameter,
                diameter
            )
        )
    }
    
    // MARK: - Shadow Settings
    
    var enabledShadows = false
    
    private func enableShadows() {
        if !enabledShadows {
            let thickness = CGFloat(imageSize) / 50
            CGContextSetShadowWithColor(
                context,
                CGSizeMake(0, thickness / 2),
                thickness / 2,
                UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
            )
            
            enabledShadows = true
        }
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