import CoreGraphics

class FoliageNodeCGDrawer: NSObject {
    
    weak var context: CGContext! {
        didSet {
            context?.setLineWidth(lineWidth)
        }
    }
    var imageSize = CGFloat(0)
    var maxCircleShapeSize = CGFloat(0)
    var mirrored: Bool = false
    var lineWidth = CGFloat(1) {
        didSet {
            context.setLineWidth(lineWidth)
        }
    }
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    
    func setup(
        context: CGContext,
        imageSize: CGFloat,
        maxCircleShapeSize: CGFloat
    ) {
        self.context = context
        self.imageSize = imageSize
        self.maxCircleShapeSize = maxCircleShapeSize
    }
    
    func drawNode(_ node: FoliageNode, nextNode: FoliageNode, inContext context: CGContext) {
//        let color = node.color
        self.context.setLineWidth(2)
//        context.setFillColor(color)
//        context.setStrokeColor(color)
//        context.str
        self.context.setFillColor(gray: 1.0, alpha: 0.5)
        self.context.fill(
            CGRect(
                x: CGFloat(node.positionVector.x),
                y: CGFloat(node.positionVector.y),
                width: 1.0,
                height: 1.0
            )
        )
    
        if mirrored {
            self.context.fill(
                CGRect(
                    x: imageSize - CGFloat(node.positionVector.x),
                    y: CGFloat(node.positionVector.y),
                    width: 4.0,
                    height: 4.0
                )
            )
        } else {
//            context.beginPath()
//            let point = CGPoint(x: CGFloat(node.x), y: CGFloat(node.y))
//            context.move(to: point)
        }
        
    //        if !mirrored {
    //            context.addLine(to: nextNode.point())
    //            context.closePath()
    //            context.drawPath(using: CGPathDrawingMode.stroke)
    //        }
    }
}
