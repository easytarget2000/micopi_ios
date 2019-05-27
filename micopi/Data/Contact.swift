import Foundation

struct Contact: Equatable {
    
    let identifier: String
    let fullName: String
    let mainEmailAddress: String?
    let mainPhoneNumber: String?
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
