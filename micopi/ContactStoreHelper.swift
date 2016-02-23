//
//  AddressBookGate.swift
//  Micopi
//
//  Created by Michel on 23/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import Contacts

class ContactStoreHelper {
    
    static let sharedInstance = ContactStoreHelper()
    
    
    func open() {

        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        
    }
    

}
