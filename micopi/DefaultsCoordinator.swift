//
//  DefaultsCoordinator.swift
//  micopi
//
//  Created by Michel Sievers on 15/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import Foundation

class DefaultsCoordinator {
    
    static func set(preferredNumberOfInitials num: Int) {
        let defaults = UserDefaults.standard
        defaults.set(num, forKey: "number_of_initials")
        defaults.synchronize()
    }
    
    static func preferredNumberOfInitials() -> Int {
        let defaults = UserDefaults.standard
        if let num = defaults.object(forKey: "number_of_initials") {
            return num as! Int
        } else {
            return 2
        }
    }
    
    static func set(askBeforeOverwrite ask: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(ask, forKey: "ask_overwrite")
        defaults.synchronize()
    }
    
    static func askBeforeOverwrite() -> Bool {
        let defaults = UserDefaults.standard
        if let num = defaults.object(forKey: "ask_overwrite") {
            return num as! Bool
        } else {
            return true
        }
    }
    
    static func set(overdrawExistingImage overdraw: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(overdraw, forKey: "overdraw")
        defaults.synchronize()
    }
    
    static func overdrawExistingImage() -> Bool {
        let defaults = UserDefaults.standard
        if let num = defaults.object(forKey: "overdraw") {
            return num as! Bool
        } else {
            return true
        }
    }

}
