import UIKit.UIImage

typealias ContactImageEngineCallback
    = (ContactHashWrapper?, UIImage?, Bool, Bool) -> ()

class ContactImageEngine: NSObject {
    
    static let defaultImageSize = 1600.0
    var contactWrappers: [ContactHashWrapper]!
    var backgroundColor: ARGBColor!
    var initialsAlpha = 0.0//0.8
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
    
    func generateAndDrawAsync(callback: @escaping ContactImageEngineCallback) {
        stopped = false
        globalDispatchQueue.async {
            // Background thread
            for contactWrapper in self.contactWrappers {
                self.generateAndDraw(
                    contactWrapper: contactWrapper,
                    callback: callback
                )
            }
        }
    }
    
    func stop() {
        stopped = true
    }
    
    // TODO: Store weak reference?
    
    func generateAndDraw(
        contactWrapper: ContactHashWrapper,
        callback: @escaping ContactImageEngineCallback
    ) {
        guard !stopped else {
            getImageAndCallback(callback, contactWrapper: contactWrapper)
            return
        }
        
        let hashValue = contactWrapper.hashValue
        randomNumberGenerator.startPoint = hashValue
        randomColorGenerator.randomNumberGenerator = randomNumberGenerator
        backgroundColor = colorPalette.color(
            randomNumberGenerator: randomNumberGenerator
        )
        
        UIGraphicsBeginImageContext(cgImageSize)
        let context = UIGraphicsGetCurrentContext()!
        
        drawBackgroundInContext(context)
        simulateAndDrawFoliageForContact(
            contactWrapper,
            inContext: context,
            callback: callback
        )

        drawInitialsOfContact(contactWrapper.contact, inContext: context)
        
        getImageAndCallback(
            callback,
            contactWrapper: contactWrapper,
            completed: true
        )
        UIGraphicsEndImageContext()
    }
    
    fileprivate func getImageAndCallback(
        _ callback: @escaping ContactImageEngineCallback,
        contactWrapper: ContactHashWrapper,
        completed: Bool = false
    ) {
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let completedLast = completed && contactWrappers.last == contactWrapper
        mainDispatchQueue.async(
            execute: {
                callback(
                    self.stopped ? nil : contactWrapper,
                    self.stopped ? nil : generatedImage,
                    completed,
                    self.stopped || completedLast
                )
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
    
    fileprivate func drawInitialsOfContact(
        _ contact: Contact,
        inContext context: CGContext
    ) {
        let initials = contact.initials
        let initialsColor = backgroundColor.colorWithAlpha(initialsAlpha)
        initialsDrawer.drawInitialsInImageContext(
            initials,
            color: initialsColor,
            imageSize: CGFloat(imageSize)
        )
    }
    
    fileprivate func simulateAndDrawFoliageForContact(
        _ contactWrapper: ContactHashWrapper,
        inContext context: CGContext,
        callback: @escaping ContactImageEngineCallback
    ) {
        foliageGenerator.setup(imageSize: imageSize, colorPalette: colorPalette)
        let numOfRoundsPerCallback = 8
        let numOfTotalRounds = 512
        for roundsCounter in 0 ..< numOfTotalRounds {
            foliageGenerator.drawAndUpdate(context: context, numOfRounds: 1)
            if roundsCounter % numOfRoundsPerCallback == 0 || stopped {
                getImageAndCallback(
                    callback,
                    contactWrapper: contactWrapper,
                    completed: false
                )
            }
            
            if stopped {
                break
            }
        }
    }
}
