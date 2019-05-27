class ContactHashWrapper {
    
    let contact: Contact
    var modifier: Int = 0
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    func increaseModifier() {
        modifier += 1
    }
    
    func decreaseModifier() {
        modifier -= 1
    }
    
}
