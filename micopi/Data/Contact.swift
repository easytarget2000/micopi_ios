//
//  File.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import Foundation

class Contact {
    
    var displayName: String?
    
    var emailAddress: String?
    
    var phoneNumber: String?
    
    private var modification = 0
    
    
    
    var md5: String {
        get {
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            
            let info = "\(displayName)___\(emailAddress)___\(phoneNumber)___\(modification)"
            
            if let data = info.dataUsingEncoding(NSUTF8StringEncoding) {
                CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            }
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return digestHex
        }
        
    }
    
    func increaseModification() {
        ++modification
    }
    
    func decreaseModification() {
        --modification
    }
}