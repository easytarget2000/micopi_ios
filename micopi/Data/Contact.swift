struct Contact: Equatable {
    
    let identifier: String
    let givenName: String
    let familyName: String?
    let nickname: String?
    let mainEmailAddress: String?
    let mainPhoneNumber: String?
    let hasPicture: Bool
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var initials: String {
        get {
            let fullName = givenName + " " + (familyName ?? "")
            let words = fullName.components(separatedBy: " ")
            return words.reduce(
                "",
                {
                    (interimResult, word) -> String in
                    guard let initial = word.first else {
                        return interimResult
                    }
                    
                    return interimResult + String(initial)
                }
            )
        }
    }
}
