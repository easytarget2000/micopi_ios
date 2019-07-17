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
        let mirrored = randomNumberGenerator.b(withChance: 0.5)
        
        let center = imageSize / 2
        let distributionRadius = imageSize * 0.25
        let distributionAngle = randomNumberGenerator.f(smallerThan: .pi * 2)
        
        foliages = []
        for i in 0 ..< numberOfShapes {
            
            let minRadius = imageSize / 32.0
            let foliage = Foliage(
                worldSize: imageSize,
                numOfInitialNodes: 64,
                maxJitter: imageSize / 128.0,
                startX: center,
                startY: center,
                radius: imageSize / 16.0
            )
            //            let foliageX: Float
            //            let foliageY: Float
            //            if i < 4 {
            //                foliageX = randomNumberGenerator.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
            //                foliageY = randomNumberGenerator.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
            //            } else {
            //                foliageX = randomNumberGenerator.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
            //                foliageY = randomNumberGenerator.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
            //            }
            
            let angleOfFoliagePoint = 0.0//distributionAngle + (piTwo * Float(i) / Float(numberOfShapes))
            
//            let foliageX = center + (distributionRadius * cos(angleOfFoliagePoint))
//            let foliageY = center + (distributionRadius * sin(angleOfFoliagePoint))
            
//            if randomNumberGenerator.b(withChance: 0.5) {
//                foliage.start(inCircleAtX: foliageX, atY: foliageY)
//            } else {
//                foliage.start(inPolygonAroundX: foliageX, y: foliageY)
//            }
            
//            var color1: CGColor
//            var color2: CGColor
//
//            if let image = backgroundImage {
//                color1 = image.get(cgColorAtX: Int(foliageX), y: Int(foliageY), alpha: 0.3)
//                let color2X = foliageX < imageSize - 5 ? Int(foliageX + 5) : Int(foliageX + 5)
//                let color2Y = foliageY < imageSize - 5 ? Int(foliageY + 5) : Int(foliageY + 5)
//                color2 = image.get(cgColorAtX: color2X, y: color2Y, alpha: 0.5)
//            } else {
//                color1 = ColorPalette.randomColor(withAlpha: alpha).cgColor
//                color2 = ColorPalette.randomColor(withAlpha: alpha).cgColor
//            }
            
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
        nodeDrawer.setup(
            context: context,
            imageSize: CGFloat(imageSize),
            maxCircleShapeSize: 16.0
        )
        
        let isAlive = foliage.updateAndDraw(nodeDrawer: nodeDrawer, context: context)
        nodeDrawer.context = nil
    }
}
