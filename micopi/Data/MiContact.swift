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
    
    lazy var displayName: String? = {
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

        return constructedName.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }()
    
    var emailAddress: String?
    
    lazy var phoneNumber: String? = {
        if let cnPhoneNumber = self.cn.phoneNumbers[0].value as? CNPhoneNumber {
            return cnPhoneNumber.stringValue
        }
        
        return ""
    }()
    
    private var modification = 0
    
    var md5: [Int] {
        get {
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            
            let info = "\(displayName)___\(emailAddress)___\(phoneNumber)___\(modification)"
            
            if let data = info.dataUsingEncoding(NSUTF8StringEncoding) {
                CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            }
            
            return digest.map { Int($0) }
        }
        
    }
    
    func increaseModification() {
        ++modification
    }
    
    func decreaseModification() {
        --modification
    }
}