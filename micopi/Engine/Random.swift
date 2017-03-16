//
//  NumberSource.swift
//  micopi
//
//  Created by Michel Sievers on 06/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import CoreGraphics

class Random {
    
    static func i(smallerThan max: Int) -> Int {
        return Int(drand48() * Double(max))
    }
    
    static func i(largerThan min: Int, smallerThan max: Int) -> Int {
        guard min < max else {
            return min
        }
        
        return Int(drand48() * Double(max - min)) + min
    }
    
    static func i(greater min: Int, smaller max: Int) -> Int {
        guard min < max else {
            return min
        }
        
        return Int(drand48() * Double(max - min)) + min
    }
    
    static func b(withChance chance: Double) -> Bool {
        guard chance > 0 else {
            return false
        }
        
        guard chance < 1 else {
            return true
        }
        
        return Int(drand48() * (1/chance)) % Int(1/chance) == 0
    }
    
    static func d(greater min: Double, smaller max: Double) -> Double {
        guard min < max else {
            return min
        }
        
        return (drand48() * Double(max - min)) + min
    }
    
    static func f(smallerThan max: Float) -> Float {
        return Float(drand48()) * max
    }
    
    static func f(smaller max: Float) -> Float {
        return Float(drand48()) * max
    }
    
    static func f(smaller max: Float, greater min: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return (Float(drand48()) * (max - min)) + min
    }
    
    static func f(largerThan min: Float, smallerThan max: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return Float(drand48() * Double(max - min)) + min

    }
    
    static func f(greater min: Float, smaller max: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return Float(drand48() * Double(max - min)) + min
    }
    
    static func cgF(smallerThan max: CGFloat) -> CGFloat {
        return CGFloat(drand48()) * max
    }
    
    static func cgF(smaller max: CGFloat) -> CGFloat {
        return CGFloat(drand48()) * max
    }
    
    static func cgF(greater min: CGFloat, smaller max: CGFloat) -> CGFloat {
        guard min < max else {
            return min
        }
        
        return CGFloat(drand48() * Double(max - min)) + min
    }

}
