import UIKit

class ContactHashWrapperViewModel: NSObject {
    
    var contactWrapper: ContactHashWrapper! {
        didSet {
            initValues()
        }
    }
    @IBOutlet var contactImageDrawer: ContactImageEngine!
    @IBOutlet var contactWriter: ContactWriter!
    var displayName: Dynamic<String> = Dynamic("")
    var isGenerating: Dynamic<Bool> = Dynamic(false)
    fileprivate(set) var generatedImage: Dynamic<UIImage?> = Dynamic(nil)
    
    func generatePreviousImage() {
        contactWrapper.decreaseModifier()
        generateImage()
    }
    
    func generateNextImage() {
        contactWrapper.increaseModifier()
        generateImage()
    }
    
    func assignImageToContact() {
        guard let generatedImage = generatedImage.value ?? nil else {
            return
        }
        
        contactWriter.assignImage(
            generatedImage,
            toContact: contactWrapper.cnContact
        )
    }
    
    fileprivate func initValues() {
        displayName.value = buildDisplayName()
        generateImage()
    }
    
    fileprivate func generateImage() {
        guard !(isGenerating.value ?? false) else {
            return
        }
        
        guard let contactImageDrawer = contactImageDrawer else {
            return
        }
        
        isGenerating.value = true
//        generatedImage.value = nil
        
        contactImageDrawer.contactWrapper = contactWrapper
        contactImageDrawer.drawImageAsync(
            completionHandler: {
                (generatedImage) in
                self.generatedImage.value = generatedImage
                self.isGenerating.value = false
            }
        )
    }
    
    fileprivate func buildDisplayName() -> String {
        var fullName = ""
        fullName = ContactHashWrapperViewModel.appendWord(
            contactWrapper.contact.givenName,
            toString: fullName
        )
        if let nickname = contactWrapper.contact.nickname, !nickname.isEmpty {
            fullName = ContactHashWrapperViewModel.appendWord(
                "\"\(nickname)\"",
                toString: fullName
            )
        }
        fullName = ContactHashWrapperViewModel.appendWord(
            contactWrapper.contact.familyName,
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
