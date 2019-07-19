import Contacts
import UIKit.UIImage

class ContactWriter: NSObject {
    
    var contactStore = CNContactStore()
    
    func assignImage(_ image: UIImage, toContact contact: CNContact) -> Bool {
        let mutant = contact.mutableCopy() as! CNMutableContact
        
        let newImageData = image.pngData()
        mutant.imageData = newImageData
        
        do {
            let saveRequest = CNSaveRequest()
            
            saveRequest.update(mutant)
            try contactStore.execute(saveRequest)
            
            return true
        }
        catch {
            NSLog(
                "ERROR: ContactWriter: assignImage(): "
                    + error.localizedDescription
            )
            return false
        }
    }
    
    func deleteImageOfContact(_ contact: CNContact) -> Bool {
        let mutant = contact.mutableCopy() as! CNMutableContact
        mutant.imageData = nil
        
        do {
            let saveRequest = CNSaveRequest()
            
            saveRequest.update(mutant)
            try contactStore.execute(saveRequest)
            
            return true
        }
        catch {
            NSLog(
                "ERROR: ContactWriter: assignImage(): "
                    + error.localizedDescription
            )
            return false
        }
        
    }
}
