//
//  AddressBookGate.swift
//  Micopi
//
//  Created by Michel on 23/02/16.
//  Copyright © 2016 Easy Target. All rights reserved.
//

import UIKit
import Contacts

class ContactStoreViewController: UIViewController {
//    
//    func openContactStore() {
//
//        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
//        
//        requestForAccess {
//            (accessGranted) -> Void in
//            if accessGranted {
//                
//                dispatch_async(
//                    dispatch_get_main_queue(), {
//                        () -> Void in
//                        self.didFetchContacts(contacts)
//                        self.navigationController?.popViewControllerAnimated(true)
//                    }
//                )
//            }
//        }
//    }
//    
//    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
//        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
//        
//        switch authorizationStatus {
//        case .Authorized:
//            completionHandler(accessGranted: true)
//            
//        case .Denied, .NotDetermined:
//            contactStore.requestAccessForEntityType(
//                CNEntityType.Contacts,
//                completionHandler: {
//                    (access, accessError) -> Void in
//                    if access {
//                        completionHandler(accessGranted: access)
//                    } else {
//                        if authorizationStatus == CNAuthorizationStatus.Denied {
//                            dispatch_async(
//                                dispatch_get_main_queue(),
//                                {
//                                    () -> Void in
//                                    let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//                                    self.showMessage(message)
//                                }
//                            )
//                        }
//                    }
//                }
//            )
//            
//        default:
//            completionHandler(accessGranted: false)
//        }
//    }
//    
//    private func showMessage(message: String) {
//        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
//        }
//        
//        alertController.addAction(dismissAction)
//        
//        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
//        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
//        
//        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    //TODO: Force override.
//    func didFetchContacts(contacts: [CNContact]) {
//        
//    }

}
