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
        return ContactHashWrapper(contact: contact, cnContact: cnContact)
    }
    
    func convertCNContact(_ cnContact: CNContact) -> Contact {
        let firstEmailAddress = cnContact.emailAddresses.first?.value as String?
        let firstPhoneNumber = cnContact.phoneNumbers.first?.value.description
        let hasPicture = cnContact.imageDataAvailable
        
        return Contact(
            identifier: cnContact.identifier,
            givenName: cnContact.givenName,
            familyName: cnContact.familyName,
            nickname: cnContact.nickname,
            mainEmailAddress: firstEmailAddress,
            mainPhoneNumber: firstPhoneNumber,
            hasPicture: hasPicture
        )
    }
    
}
