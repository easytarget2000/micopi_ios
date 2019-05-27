class ContactHashWrapper: Hashable {
    
    let contact: Contact
    var modifier: Int = 0
    var hashable: String {
        return "\(contact.identifier),\(modifier)"
    }
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    static func == (lhs: ContactHashWrapper, rhs: ContactHashWrapper) -> Bool {
        return lhs.contact == rhs.contact && lhs.modifier == rhs.modifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashable)
    }
    
    func increaseModifier() {
        modifier += 1
    }
    
    func decreaseModifier() {
        modifier -= 1
    }
    
}
