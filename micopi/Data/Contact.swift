//
//  File.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import Contacts

class Contact {
    
    var nickname: String?
    
    var givenName: String?
    
    var middleName: String?
    
    var familyName: String?
    
    lazy var displayName: String? = {
        if let nick = self.nickname where !nick.isEmpty {
            return nick
        }
        
        var constructedName = ""
        
        if let given = self.givenName where !given.isEmpty {
            constructedName = given + " "
        }
        
        if let middle = self.middleName where !middle.isEmpty {
            constructedName += middle + " "
        }
        
        if let family = self.familyName where !family.isEmpty {
            constructedName += family
        }
        
        return constructedName.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }()
    
    var emailAddress: String?
    
    var phoneNumber: String?
    
    var birthday: String?
    
    private var modification = 0
    
    init(c: CNContact) {
        
        nickname = c.nickname
        givenName = c.givenName
        middleName = c.middleName
        familyName = c.familyName
        
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