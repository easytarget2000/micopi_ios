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
            if let email = self.emailAddress, !email.isEmpty {
                return email
            } else if let phone = self.phoneNumber, !phone.isEmpty {
                return phone
            } else {
                return ""
            }
        } else {
            return constructedName.trimmingCharacters(
                in: CharacterSet.whitespacesAndNewlines
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
    
    var initials: String? {
        get {
            let numberOfInitials = DefaultsCoordinator.preferredNumberOfInitials()
            guard numberOfInitials > 0 else {
                return nil
            }
            
            guard !displayName.isEmpty else {
                return nil
            }
            
            if let firstChar = displayName.characters.first {
                
                if numberOfInitials == 1 {
                    return String(firstChar)
                }
                
                if let secondChar = self.cn.familyName.characters.first {
                    return String(firstChar) + String(secondChar)
                } else if let secondChar = self.cn.middleName.characters.first {
                    return String(firstChar) + String(secondChar)
                } else {
                    return String(firstChar)
                }
            } else {
                return nil
            }
            
        }
    }
    
    fileprivate var modification = 0
    
    var md5: [Int] {
        get {
            let info = "\(displayName)___\(emailAddress)___\(phoneNumber)___\(modification)"
            let data = info.data(using: String.Encoding.utf8)!
            
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
            
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
