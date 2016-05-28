//
//  CollorCollection.swift
//  micopi
//
//  Created by Michel on 23/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit

class ColorCollection {
    
    static let palette = [
        UIColor(netHex:0x00E676),
        UIColor(netHex:0xFF9800),
        UIColor(netHex:0xe6c484),
        UIColor.blackColor(),
        UIColor(netHex:0xD3D3D3),
        UIColor(netHex:0xCDDC39),
        UIColor(netHex:0xf4c4ba),
        UIColor(netHex:0xFFA000),
        UIColor(netHex:0xFFAB40),
        UIColor(netHex:0x9F9F9F),
        UIColor(netHex:0x555555),
        UIColor.blackColor(),
        UIColor(netHex:0x7C4DFF),
        UIColor(netHex:0x3f3c37),
        UIColor(netHex:0x050505),
        UIColor(netHex:0x0288D1),
        UIColor(netHex:0x444444),
        UIColor(netHex:0xD32F2F),
        UIColor(netHex:0x29B6F6),
        UIColor(netHex:0xFFF59D),
        UIColor(netHex:0xFFC107),
        UIColor(netHex:0x7C4DFF),
        UIColor.blackColor(),
        UIColor(netHex:0xF44336),
        UIColor(netHex:0xe6c484),
        UIColor(netHex:0x141414),
        UIColor(netHex:0xFFEB3B),
        UIColor(netHex:0x333333),
        UIColor.blackColor(),
        UIColor(netHex:0x666666),
        UIColor(netHex:0x2196F3),
        UIColor(netHex:0x777777),
        UIColor(netHex:0xFF4081),
        UIColor(netHex:0x536DFE),
        UIColor.blackColor(),
        UIColor(netHex:0xC2185B),
        UIColor(netHex:0xF57C00),
        UIColor(netHex:0x4CAF50),
        UIColor(netHex:0xD3D3D3),
        UIColor(netHex:0x303F9F),
        UIColor(netHex:0xf0ebe5),
        UIColor(netHex:0x3F51B5),
        UIColor(netHex:0xCCCCCC),
        UIColor(netHex:0xFF9500),
        UIColor(netHex:0x03A9F4),
        UIColor(netHex:0xAD1457),
        UIColor(netHex:0xE64A19),
        UIColor.blackColor(),
        UIColor(netHex:0xFFF9C4),
        UIColor(netHex:0xFF5722),
        UIColor(netHex:0x00796B),
        UIColor(netHex:0x009688),
        UIColor(netHex:0xBBDEFB),
        UIColor(netHex:0x80CBC4),
        UIColor(netHex:0x777777),
        UIColor(netHex:0x524942),
        UIColor(netHex:0x437478),
        UIColor(netHex:0x009688),
        UIColor.blackColor(),
        UIColor(netHex:0xFF5252),
        UIColor(netHex:0x1976D2),
        UIColor(netHex:0xA7A7A7)
    ]

    static let backgroundGradientColors = [
        UIColor(netHex:0x55EFCB).CGColor,
        UIColor(netHex:0x34AADC).CGColor
    ]

//    static func color(i: Int) -> UIColor {
//        return palette[i % (palette.count - 1)]
//    }
    
    static func color(i: Int) -> UIColor {
        return palette[i % (palette.count - 1)]
    }
    
    static func color(i: Int, alpha: CGFloat) -> UIColor {
        return palette[i % (palette.count - 1)].colorWithAlphaComponent(alpha)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(netHex: Int) {
        self.init(
            red:(netHex >> 16) & 0xff,
            green:(netHex >> 8) & 0xff,
            blue:netHex & 0xff
        )
    }
}