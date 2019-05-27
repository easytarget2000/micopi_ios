import Contacts.CNContact

struct ContactCNConverter {
    
    func convertCNContacts(_ cnContacts: [CNContact]) -> [Contact] {
        return cnContacts.map({
                (cnContact) -> Contact in
                return convertCNContact(cnContact)
            }
        )
    }
    
    func convertCNContact(_ cnContact: CNContact) -> Contact {
        let givenName = cnContact.givenName.isEmpty ? nil : cnContact.givenName
        let nickname = cnContact.nickname.isEmpty ? nil : cnContact.nickname
        let familyName = cnContact.familyName.isEmpty ?
            nil : cnContact.familyName
        var fullName = ""
        if let givenName = givenName {
            fullName += givenName
        }
        if let nickname = nickname {
            fullName += "\"\(nickname)\""
        }
        if let familyName = familyName {
            fullName += familyName
        }
        
        let firstEmailAddress = cnContact.emailAddresses.first?.value as String?
        let firstPhoneNumber = cnContact.phoneNumbers.first?.value.description
        
        return Contact(
            fullName: fullName,
            mainEmailAddress: firstEmailAddress,
            mainPhoneNumber: firstPhoneNumber
        )
    }
    
}
