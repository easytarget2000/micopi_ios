import UIKit.UIImage

class ContactImageEngine: NSObject {
    
    static let defaultImageSize = 1600.0
    var contactWrapper: ContactHashWrapper! {
        didSet {
            let hashValue = contactWrapper.hashValue
            randomNumberGenerator.startPoint = hashValue
            randomColorGenerator.randomNumberGenerator = randomNumberGenerator
            colorPalette.setColorsRandomly(
                randomColorGenerator: randomColorGenerator
            )
        }
    }
    let backgroundColor = ARGBColor.black
    //        let backgroundColor = colorPalette.color(
    //            randomNumberGenerator: randomNumberGenerator
    //        )
    var imageSize: Double = ContactImageEngine.defaultImageSize
    var cgImageSize: CGSize {
        get {
            return CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize))
        }
    }
    var globalDispatchQueue = DispatchQueue.global()
    var mainDispatchQueue = DispatchQueue.main
    @IBOutlet var randomNumberGenerator: RandomNumberGenerator!
    @IBOutlet var randomColorGenerator: RandomColorGenerator!
    @IBOutlet var colorPalette: ARGBColorPalette!
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    @IBOutlet var backgroundDrawer: BackgroundCGDrawer!
    @IBOutlet var gradientDrawer: GradientCGDrawer!
    @IBOutlet var initialsDrawer: InitialsUIDrawer!
    @IBOutlet var foliageGenerator: FoliageCGGenerator!
    fileprivate var stopped = false
    
    func drawImageAsync(
        completionHandler: @escaping (UIImage) -> ()
    ) {
        globalDispatchQueue.async {
            // Background thread
            
            let generatedImage = self.generateAndDraw()
            
            self.mainDispatchQueue.async(execute: {
                    completionHandler(generatedImage)
                }
            )
        }
    }
    
    func stop() {
        stopped = true
    }
    
    func generateAndDraw() -> UIImage {
        stopped = false
        
        UIGraphicsBeginImageContext(cgImageSize)
        let context = UIGraphicsGetCurrentContext()!
        
        drawBackgroundInContext(context)
        simulateAndDrawFoliageInContext(context)
        drawInitialsInContext(context)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return generatedImage
    }
    
    fileprivate func drawBackgroundInContext(
        _ context: CGContext
    ) {
        backgroundDrawer.setup(context: context, imageSize: CGFloat(imageSize))
        backgroundDrawer.fillWithColor(backgroundColor)
        backgroundDrawer.context = nil
    }
    
    fileprivate func drawInitialsInContext(_ context: CGContext
    ) {
        let initials = contactWrapper.contact.initials
        let initialsColor = backgroundColor.colorWithAlpha(0.5)
        initialsDrawer.drawInitialsInImageContext(
            initials,
            color: initialsColor,
            imageSize: CGFloat(imageSize)
        )
    }
    
    fileprivate func simulateAndDrawFoliageInContext(_ context: CGContext) {
        foliageGenerator.setup(imageSize: imageSize, colorPalette: colorPalette)
        foliageGenerator.drawCompletely(context: context)
    }
}
