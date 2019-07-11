import UIKit.UIImage

class ContactImageEngine: NSObject {
    
    static let defaultImageSize = 1600.0
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    @IBOutlet var randomNumberGenerator: RandomNumberGenerator!
    @IBOutlet var randomColorGenerator: RandomColorGenerator!
    @IBOutlet var colorPalette: ARGBColorPalette!
    @IBOutlet var gradientDrawer: GradientCGDrawer!
    @IBOutlet var initialsDrawer: InitialsDrawer!
    fileprivate var stopped = false
    
    func drawImageForContactAsync(
        contactWrapper: ContactHashWrapper,
        imageSize: Double = ContactImageEngine.defaultImageSize,
        completionHandler: @escaping (UIImage) -> ()
    ) {
        globalDispatchQueue.async {
            // Background thread
            
            let generatedImage = self.drawImageForContact(
                contactWrapper: contactWrapper,
                imageSize: imageSize
            )
            
            self.mainDispatchQueue.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func stop() {
        stopped = true
    }
    
    func drawImageForContact(
        contactWrapper: ContactHashWrapper,
        imageSize: Double = ContactImageEngine.defaultImageSize
    ) -> UIImage {
        stopped = false
        setup(contactWrapper: contactWrapper)
        
        let cgImageSize = CGFloat(imageSize)
        let contextSize = CGSize(width: cgImageSize, height: cgImageSize)
    
        UIGraphicsBeginImageContext(contextSize)
        let context = UIGraphicsGetCurrentContext()!
        
        let backgroundColors = [
            colorPalette.color(randomNumber: randomNumberGenerator.int),
            colorPalette.color(randomNumber: randomNumberGenerator.int)
        ]
        
        gradientDrawer.drawColors(
            backgroundColors,
            inContext: context,
            size: contextSize
        )
        
        let displayedInitials = "ABC"
        initialsDrawer.drawInitialsInImageContext(
            displayedInitials,
            imageSize: cgImageSize
        )
        
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return generatedImage
    }
    
    func setup(contactWrapper: ContactHashWrapper) {
//        randomNumberGenerator
        randomColorGenerator.randomNumberGenerator = randomNumberGenerator
        colorPalette.setColorsRandomly(
            randomColorGenerator: randomColorGenerator
        )
    }
    
}
