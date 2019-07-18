import UIKit.UIImage

class ContactImageEngine: NSObject {
    
    static let defaultImageSize = 1600.0
    var contactWrapper: ContactHashWrapper! {
        didSet {
            let hashValue = contactWrapper.hashValue
            randomNumberGenerator.startPoint = hashValue
            randomColorGenerator.randomNumberGenerator = randomNumberGenerator
            backgroundColor = colorPalette.color(
                randomNumberGenerator: randomNumberGenerator
            )
        }
    }
    var backgroundColor: ARGBColor!
    var initialsAlpha = 0.8
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
    
    func drawImageAsync(callback: @escaping (UIImage, Bool) -> ()) {
        globalDispatchQueue.async {
            // Background thread
            
            self.generateAndDraw(callback: callback)
        }
    }
    
    func stop() {
        stopped = true
    }
    
    // TODO: Typealias
    // TODO: Store weak reference?
    
    func generateAndDraw(callback: @escaping (UIImage, Bool) -> ()) {
        stopped = false
        
        UIGraphicsBeginImageContext(cgImageSize)
        let context = UIGraphicsGetCurrentContext()!
        
        drawBackgroundInContext(context)
        simulateAndDrawFoliageInContext(context, callback: callback)
        drawInitialsInContext(context)
        
        getImageAndCallback(callback, completed: true)
        UIGraphicsEndImageContext()
    }
    
    fileprivate func getImageAndCallback(
        _ callback: @escaping (UIImage, Bool) -> (),
        completed: Bool = false
    ) {
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        mainDispatchQueue.async(
            execute: {
                callback(generatedImage, completed)
            }
        )
    }
    
    fileprivate func drawBackgroundInContext(
        _ context: CGContext
    ) {
        backgroundDrawer.setup(context: context, imageSize: CGFloat(imageSize))
        backgroundDrawer.fillWithColor(backgroundColor)
        backgroundDrawer.context = nil
    }
    
    fileprivate func drawInitialsInContext(_ context: CGContext) {
        let initials = contactWrapper.contact.initials
        let initialsColor = backgroundColor.colorWithAlpha(initialsAlpha)
        initialsDrawer.drawInitialsInImageContext(
            initials,
            color: initialsColor,
            imageSize: CGFloat(imageSize)
        )
    }
    
    fileprivate func simulateAndDrawFoliageInContext(
        _ context: CGContext,
        callback: @escaping (UIImage, Bool) -> ()
    ) {
        foliageGenerator.setup(imageSize: imageSize, colorPalette: colorPalette)
        let numOfRoundsPerCallback = 8
        let numOfTotalRounds = 512
        for roundsCounter in 0 ..< numOfTotalRounds {
            foliageGenerator.drawAndUpdate(context: context, numOfRounds: 1)
            if roundsCounter % numOfRoundsPerCallback == 0 {
                getImageAndCallback(callback, completed: false)
            }
        }
    }
}
