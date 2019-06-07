import CoreGraphics

struct FoliageNodeCGDrawer {
    
    let context: CGContext
    let imageSize: CGFloat
    let maxCircleShapeSize: CGFloat
    let randomGenerator: RandomCGNumberGenerator
    let color1: CGColor
    let color2: CGColor
    let shape: Int
    let mirrored: Bool
    
    init(
        context: CGContext,
        imageSize: CGFloat,
        maxCircleShapeSize: CGFloat,
        randomGenerator: RandomCGNumberGenerator = RandomCGNumberGenerator(),
        color1: CGColor,
        color2: CGColor,
        shape: Int = 0,
        lineWidth: CGFloat = 1.0,
        mirrored: Bool = false
    ) {
        self.context = context
        self.imageSize = imageSize
        self.maxCircleShapeSize = maxCircleShapeSize
        self.randomGenerator = randomGenerator
        self.color1 = color1
        self.color2 = color2
        self.shape = shape
        self.mirrored = mirrored
        
        context.setStrokeColor(color1)
        context.setLineWidth(lineWidth)
    }
    
    func drawNode(_ node: FoliageNode, nextNode: FoliageNode) {
        
        if shape == 1 {
            context.setStrokeColor(color2)
            context.strokeEllipse(
                in: CGRect(
                    x: CGFloat(node.x + 1.0),
                    y: CGFloat(node.y + 1.0),
                    width: randomGenerator.cgF(smallerThan: maxCircleShapeSize),
                    height: randomGenerator.cgF(smallerThan: maxCircleShapeSize)
                )
            )
        } else {
            context.setFillColor(color2)
            context.fill(
                CGRect(
                    x: CGFloat(node.x + 1.0),
                    y: CGFloat(node.y + 1.0),
                    width: 1,
                    height: 1
                )
            )
        }
        
        if mirrored {
            if shape == 1 {
                context.setStrokeColor(color2)
                context.strokeEllipse(
                    in: CGRect(
                        x: CGFloat(node.x + 1.0),
                        y: CGFloat(node.y + 1.0),
                        width: randomGenerator.cgF(smallerThan: maxCircleShapeSize),
                        height: randomGenerator.cgF(smallerThan: maxCircleShapeSize)
                    )
                )
            } else {
                context.setFillColor(color1)
                context.fill(
                    CGRect(
                        x: imageSize - CGFloat(node.x),
                        y: CGFloat(node.y),
                        width: 1,
                        height: 1
                    )
                )
            }
        } else {
            context.beginPath()
            let point = CGPoint(x: CGFloat(node.x), y: CGFloat(node.y))
            context.move(to: point)
        }
        
//        if !mirrored {
//            context.addLine(to: nextNode.point())
//            context.closePath()
//            context.drawPath(using: CGPathDrawingMode.stroke)
//        }
    }
}
