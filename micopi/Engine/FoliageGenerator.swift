import CoreGraphics

struct FoliageGenerator {
    
    let context: CGContext
    let imageSize: Double
    let randomGenerator = RandomNumberGenerator()
    let foregroundColor1: CGColor
    let foregroundColor2: CGColor
    
    func generate() {
        let numberOfShapes = randomGenerator.i(largerThan: 2, smallerThan: 7)
        let mirrored = randomGenerator.b(withChance: 0.5)
        //        let alpha: CGFloat = (mirrored ? 0.2 : 0.1) / CGFloat(numberOfShapes)
        let alpha = (mirrored ? 4 : 1) * randomGenerator.cgF(greater: 0.02, smaller: 0.08)
        let mutableColor1 = randomGenerator.b(withChance: 0.2)
        let mutableColor2 = randomGenerator.b(withChance: 0.2)
        
        let center = imageSize / 2
        let distributionRadius = imageSize * 0.25
        let distributionAngle = randomGenerator.f(smallerThan: .pi * 2)
        
        for i in 0 ..< numberOfShapes {
            
            let foliage = Foliage(imageSize: imageSize, mirroredMode: mirrored)
            //            let foliageX: Float
            //            let foliageY: Float
            //            if i < 4 {
            //                foliageX = randomGenerator.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
            //                foliageY = randomGenerator.f(largerThan: imageSize * 0.35, smallerThan: imageSize * 0.65)
            //            } else {
            //                foliageX = randomGenerator.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
            //                foliageY = randomGenerator.f(largerThan: imageSize * 0.05, smallerThan: imageSize * 0.95)
            //            }
            
            let angleOfFoliagePoint = 0.0//distributionAngle + (piTwo * Float(i) / Float(numberOfShapes))
            
//            let foliageX = center + (distributionRadius * cos(angleOfFoliagePoint))
//            let foliageY = center + (distributionRadius * sin(angleOfFoliagePoint))
            
//            if randomGenerator.b(withChance: 0.5) {
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
        }
    }
    
    func drawAndUpdate(context: CGContext) {
        let nodeDrawer = FoliageNodeCGDrawer(
            context: context,
            imageSize: CGFloat(imageSize),
            maxCircleShapeSize: 20,
            color1: foregroundColor1,
            color2: foregroundColor2
        )
        
        
    }
}
