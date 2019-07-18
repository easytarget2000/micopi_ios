import Foundation

class ContactViewModel: NSObject {
    
    func displayName(contact: Contact) -> String {
        var fullName = ""
        fullName = ContactViewModel.appendWord(
            contact.givenName,
            toString: fullName
        )
        if let nickname = contact.nickname, !nickname.isEmpty {
            fullName = ContactViewModel.appendWord(
                "\"\(nickname)\"",
                toString: fullName
            )
        }
        fullName = ContactViewModel.appendWord(
            contact.familyName,
            toString: fullName
        )
        return fullName
    }
    
    fileprivate static func appendWord(
        _ word: String?,
        toString string: String
    ) -> String {
        var newString = string
        
        guard let word = word, !word.isEmpty else {
            return newString
        }
        
        if !newString.isEmpty {
            newString += " "
        }
        newString += word
        return newString
    }

}
