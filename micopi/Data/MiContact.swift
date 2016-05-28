//
//  File.swift
//  micopi
//
//  Created by Michel on 22/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import Contacts

class MiContact {
    
    let cn: CNContact
    
    init(cn: CNContact) {
        self.cn = cn
    }
    
    lazy var displayName: String = {
        if !self.cn.nickname.isEmpty {
            return self.cn.nickname
        }
        
        var constructedName = ""
        
        if !self.cn.givenName.isEmpty {
            constructedName = self.cn.givenName + " "
        }
        
        if !self.cn.middleName.isEmpty {
            constructedName += self.cn.middleName + " "
        }
        
        if !self.cn.familyName.isEmpty {
            constructedName += self.cn.familyName
        }
        
        if constructedName.isEmpty {
            if let email = self.emailAddress where !email.isEmpty {
                return email
            } else if let phone = self.phoneNumber where !phone.isEmpty {
                return phone
            } else {
                return ""
            }
        } else {
            return constructedName.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
        }
        
    }()
    
    var emailAddress: String?
    
    lazy var phoneNumber: String? = {
        if self.cn.phoneNumbers.count > 0, let cnPhoneNumber = self.cn.phoneNumbers[0].value as? CNPhoneNumber {
            return cnPhoneNumber.stringValue
        }
        
        return ""
    }()
    
    var initials: String {
        get {
            guard !displayName.isEmpty else {
                return ""
            }
            
            let firstChars = displayName.characters
            let firstChar = firstChars.first
            
            if let secondChar = self.cn.familyName.characters.first {
                return String(firstChar) + String(secondChar)
            } else if let secondChar = self.cn.middleName.characters.first {
                return String(firstChar) + String(secondChar)
            } else {
                return String(firstChar)
            }
        }
    }
    
    private var modification = 0
    
    var md5: [Int] {
        get {
            let info = "\(displayName)___\(emailAddress)___\(phoneNumber)___\(modification)"
            let data = info.dataUsingEncoding(NSUTF8StringEncoding)!
            
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)

            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            
            return digest.map { Int($0) }
        }
        
    }
    
    func increaseModification() {
        modification += 1
    }
    
    func decreaseModification() {
        modification -= 1
    }
}