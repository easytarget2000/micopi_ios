import CoreGraphics

class FoliageNodeCGDrawer: NSObject {
    
    weak var context: CGContext!
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    
    func startLine(
        firstNode: FoliageNode,
        gray: Double = 1.0,
        alpha: Double = 0.9
    ) {
        context.setLineWidth(1)
        context.setStrokeColor(gray: CGFloat(gray), alpha: CGFloat(alpha))
        context.move(to: FoliageNodeCGDrawer.pointFromNode(firstNode))
    }
    
    func addNodeToLine(node: FoliageNode) {
        context.addLine(to: FoliageNodeCGDrawer.pointFromNode(node))
    }
    
    func closeAndDrawLine() {
        context.strokePath()
    }
    
    
//    func drawNode(_ node: FoliageNode, nextNode: FoliageNode, inContext context: CGContext) {

//        context.move(to: FoliageNodeCGDrawer.pointFromNode(node))
        //        self.context.fill(
//            CGRect(
//                x: CGFloat(node.positionVector.x),
//                y: CGFloat(node.positionVector.y),
//                width: 1.0,
//                height: 1.0
//            )
//        )
    
//        if mirrored {
//            self.context.fill(
//                CGRect(
//                    x: imageSize - CGFloat(node.positionVector.x),
//                    y: CGFloat(node.positionVector.y),
//                    width: 4.0,
//                    height: 4.0
//                )
//            )
//        } else {
//            context.beginPath()
//            let point = CGPoint(x: CGFloat(node.x), y: CGFloat(node.y))
//            context.move(to: point)
//        }
        
    //        if !mirrored {
    //            context.addLine(to: nextNode.point())
    //            context.closePath()
    //            context.drawPath(using: CGPathDrawingMode.stroke)
    //        }
//    }
    
    fileprivate static func pointFromNode(_ node: FoliageNode) -> CGPoint {
        return CGPoint(x: node.positionVector.x, y: node.positionVector.y)
    }
}
