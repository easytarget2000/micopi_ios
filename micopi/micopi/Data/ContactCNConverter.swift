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
        var fullName = ""
        fullName = ContactCNConverter.appendWord(
            cnContact.givenName,
            toString: fullName
        )
        fullName = ContactCNConverter.appendWord(
            cnContact.nickname,
            toString: "\"\(cnContact.nickname)\""
        )
        fullName = ContactCNConverter.appendWord(
            cnContact.familyName,
            toString: fullName
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
