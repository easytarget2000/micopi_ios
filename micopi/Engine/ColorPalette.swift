//
//  ColorPalette.swift
//  micopi
//
//  Created by Michel Sievers on 27/02/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import UIKit

class ColorPalette {
    
    static func randomColor(withAlpha alpha: CGFloat) -> UIColor {
        let randomRed = (0.5 * CGFloat(drand48()))
        let randomGreen = (0.5 * CGFloat(drand48()))
        let randomBlue = (0.5 * CGFloat(drand48()))
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }

    static func randomGradient() -> Array<CGColor> {
        return [
            randomColor(withAlpha: 1).cgColor,
            randomColor(withAlpha: 1).cgColor
        ]
    }
    
    static let backgroundGradient = [
        UIColor(netHex:0x55EFCB).cgColor,
        UIColor(netHex:0x34AADC).cgColor
    ]
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
    
    convenience init(netHex:Int) {
        self.init(
            red:(netHex >> 16) & 0xff,
            green:(netHex >> 8) & 0xff,
            blue:netHex & 0xff
        )
    }
}
