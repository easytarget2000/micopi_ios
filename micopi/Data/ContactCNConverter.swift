import Contacts.CNContact

struct ContactCNConverter {
    
    func convertCNContactsWrapped(
        _ cnContacts: [CNContact]
    ) -> [ContactHashWrapper] {
        return cnContacts.map({
                (cnContact) -> ContactHashWrapper in
                return convertCNContactWrapped(cnContact)
            }
        )
    }
    
    func convertCNContactWrapped(_ cnContact: CNContact) -> ContactHashWrapper {
        let contact = convertCNContact(cnContact)
        return ContactHashWrapper(contact: contact)
    }
    
    func convertCNContact(_ cnContact: CNContact) -> Contact {
        let fullName = ContactCNConverter.combineName(
            givenName: cnContact.givenName,
            nickname: cnContact.nickname,
            familyName: cnContact.familyName
        )
        
        let firstEmailAddress = cnContact.emailAddresses.first?.value as String?
        let firstPhoneNumber = cnContact.phoneNumbers.first?.value.description
        
        return Contact(
            identifier: cnContact.identifier,
            fullName: fullName,
            mainEmailAddress: firstEmailAddress,
            mainPhoneNumber: firstPhoneNumber
        )
    }
    
    static func combineName(
        givenName: String?,
        nickname: String? = nil,
        familyName: String? = nil
    ) -> String {
        var fullName = ""
        fullName = appendWord(givenName, toString: fullName)
        if let nickname = nickname, !nickname.isEmpty {
            fullName = appendWord("\"\(nickname)\"", toString: fullName)
        }
        fullName = ContactCNConverter.appendWord(familyName, toString: fullName)
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
