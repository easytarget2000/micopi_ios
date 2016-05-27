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
        UIColor(netHex:0xFF00E676),
        UIColor(netHex:0xFFFF9800),
        UIColor(netHex:0xFFe6c484),
        UIColor(netHex:0xFFCDDC39),
        UIColor(netHex:0xFFf4c4ba),
        UIColor(netHex:0xFFFFA000),
        UIColor(netHex:0xFFFFAB40),
        UIColor(netHex:0xFF9F9F9F),
        UIColor(netHex:0xFF555555),
        UIColor(netHex:0xFF7C4DFF),
        UIColor(netHex:0xFF3f3c37),
        UIColor(netHex:0xFF0288D1),
        UIColor(netHex:0xFFD32F2F),
        UIColor(netHex:0xFF29B6F6),
        UIColor(netHex:0xFFFFF59D),
        UIColor(netHex:0xFFFFC107),
        UIColor(netHex:0xFF7C4DFF),
        UIColor(netHex:0xFFF44336),
        UIColor(netHex:0xFFe6c484),
        UIColor(netHex:0xFF141414),
        UIColor(netHex:0xFFFFEB3B),
        UIColor(netHex:0xFF2196F3),
        UIColor(netHex:0xFF777777),
        UIColor(netHex:0xFFFF4081),
        UIColor(netHex:0xFF536DFE),
        UIColor(netHex:0xFFC2185B),
        UIColor(netHex:0xFFF57C00),
        UIColor(netHex:0xFF4CAF50),
        UIColor(netHex:0xFFD3D3D3),
        UIColor(netHex:0xFF303F9F),
        UIColor(netHex:0xFFf0ebe5),
        UIColor(netHex:0xFF3F51B5),
        UIColor(netHex:0xFF03A9F4),
        UIColor(netHex:0xFFAD1457),
        UIColor(netHex:0xFFE64A19),
        UIColor(netHex:0xFFFFF9C4),
        UIColor(netHex:0xFFFF5722),
        UIColor(netHex:0xFF00796B),
        UIColor(netHex:0xFF009688),
        UIColor(netHex:0xFFBBDEFB),
        UIColor(netHex:0xFF80CBC4),
        UIColor(netHex:0xFF524942),
        UIColor(netHex:0xFF437478),
        UIColor(netHex:0xFF009688),
        UIColor(netHex:0xFFFF5252),
        UIColor(netHex:0xFF1976D2)
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