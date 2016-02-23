//
//  File.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import Contacts

class Contact {
    
    var displayName: String?
    
    var emailAddress: String?
    
    var phoneNumber: String?
    
    var birthday: String?
    
    private var modification = 0
    
    init(c: CNContact) {
        if c.nickname.isEmpty {
            var constructedName = ""
            if !c.givenName.isEmpty {
                constructedName = c.givenName + " "
            }
            
            if !c.middleName.isEmpty {
                constructedName += c.middleName + " "
            }
            
            if !c.familyName.isEmpty {
                constructedName += c.familyName
            }
            
            displayName = constructedName
        } else {
            displayName = c.nickname
        }
        
        if let cnPhoneNumber = c.phoneNumbers[0].value as? CNPhoneNumber {
            phoneNumber = cnPhoneNumber.stringValue
        }
        
        if let name = displayName where name.isEmpty {
            displayName = phoneNumber
        }
    }
    
    var md5: [Int] {
        get {
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            
            let info = "\(displayName)___\(emailAddress)___\(phoneNumber)___\(modification)"
            
            if let data = info.dataUsingEncoding(NSUTF8StringEncoding) {
                CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            }
            
            return digest.map { Int($0) }
            
//            var digestHex = ""
//            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//                digestHex += String(format: "%02x", digest[index])
//            }
//            
//            return digestHex.characters.map { $0.hashValue }
        }
        
    }
    
    func increaseModification() {
        ++modification
    }
    
    func decreaseModification() {
        --modification
    }
}