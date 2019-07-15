import CoreGraphics

class FoliageNodeCGDrawer: NSObject {
    
    var context: CGContext! {
        didSet {
            if let color1 = color1 {
                context.setStrokeColor(color1)
            }
            context.setLineWidth(lineWidth)
        }
    }
    var imageSize = CGFloat(0)
    var maxCircleShapeSize = CGFloat(0)
    var color1: CGColor! {
        didSet {
            context.setStrokeColor(color1)
        }
    }
    var color2: CGColor!
    var shape: Int = 0
    var mirrored: Bool = false
    var lineWidth = CGFloat(1) {
        didSet {
            context.setLineWidth(lineWidth)
        }
    }
    @IBOutlet var randomGenerator: RandomNumberGenerator!
    
    func setup(
        context: CGContext,
        imageSize: CGFloat,
        maxCircleShapeSize: CGFloat,
        color1: CGColor,
        color2: CGColor
    ) {
        self.context = context
        self.imageSize = imageSize
        self.maxCircleShapeSize = maxCircleShapeSize
        self.color1 = color1
        self.color2 = color2
    }
    
    func drawNode(_ node: FoliageNode, nextNode: FoliageNode) {
//        if shape == 1 {
            context.setStrokeColor(color2)
            context.strokeEllipse(
                in: CGRect(
                    x: CGFloat(node.x + 1.0),
                    y: CGFloat(node.y + 1.0),
                    width: 20, //maxCircleShapeSize,
                    height: 20 //maxCircleShapeSize
                )
            )
//        } else {
//            context.setFillColor(CGColor(colorSpace: CGColorSpace.sRGB, components: )
//            context.fill(
//                CGRect(
//                    x: 50.0, //CGFloat(node.x + 1.0),
//                    y: 50.0, //CGFloat(node.y + 1.0),
//                    width: 100,
//                    height: 100
//                )
//            )
//        }
        
        if mirrored {
            if shape == 1 {
                context.setStrokeColor(color2)
                context.strokeEllipse(
                    in: CGRect(
                        x: CGFloat(node.x + 1.0),
                        y: CGFloat(node.y + 1.0),
                        width: maxCircleShapeSize,
                        height: maxCircleShapeSize
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
