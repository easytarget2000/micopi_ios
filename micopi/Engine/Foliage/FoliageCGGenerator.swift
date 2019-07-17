import CoreGraphics

class FoliageCGGenerator: NSObject {
    
    var foliages = [Foliage]()
    var imageSize = Double(0)
    var color = ARGBColor(a: 0.0, r: 0.0, g: 0.0, b: 0.0)
    @IBOutlet var nodeDrawer: FoliageNodeCGDrawer!
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    @IBOutlet var randomNumberGenerator: RandomNumberGenerator!
    
    func setup(
        imageSize: Double,
        colorPalette: ARGBColorPalette
    ) {
        self.imageSize = imageSize
        
        let numberOfShapes = randomNumberGenerator.i(largerThan: 2, smallerThan: 3)
        
        let center = imageSize / 2
        
        foliages = []
        for i in 0 ..< numberOfShapes {
                        let foliage = Foliage(
                worldSize: imageSize,
                numOfInitialNodes: 64,
                maxJitter: imageSize / 256.0,
                startX: center,
                startY: center,
                radius: imageSize / 16.0
            )
            foliages.append(foliage)
        }
        
    }
    
    func drawCompletely(context: CGContext) {
        let numOfRounds = 512
        drawAndUpdate(context: context, numOfRounds: numOfRounds)
    }
    
    func drawAndUpdate(context: CGContext, numOfRounds: Int = 1) {
        for _ in 0 ..< numOfRounds {
            for foliage in foliages {
                drawAndUpdateFoliage(foliage, context: context)
            }
        }
    }
    
    fileprivate func drawAndUpdateFoliage(
        _ foliage: Foliage,
        context: CGContext
    ) {
        nodeDrawer.context = context
        let isAlive = foliage.updateAndDraw(nodeDrawer: nodeDrawer)
        nodeDrawer.context = nil
    }
}
