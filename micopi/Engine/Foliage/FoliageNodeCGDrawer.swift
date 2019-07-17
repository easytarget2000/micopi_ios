//import UIKit.UIBezierPath
import CoreGraphics

class FoliageNodeCGDrawer: NSObject {
    
    weak var context: CGContext!
//    fileprivate var path = UIBezierPath()
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    
    func startLine(
        firstNode: FoliageNode,
        gray: Double = 1.0,
        alpha: Double = 0.5
    ) {
        context.setLineWidth(2)
        context.setStrokeColor(gray: CGFloat(gray), alpha: CGFloat(alpha))
        context.move(to: FoliageNodeCGDrawer.pointFromNode(firstNode))
//        path.move(to: FoliageNodeCGDrawer.pointFromNode(firstNode))
//        let color = UIColor(white: CGFloat(gray), alpha: CGFloat(alpha))
//        color.setStroke()
    }
    
    func addNodeToLine(node: FoliageNode) {
        context.addLine(to: FoliageNodeCGDrawer.pointFromNode(node))
//        path.addLine(to: FoliageNodeCGDrawer.pointFromNode(node))
    }
    
    func closeAndDrawLine() {
//        path.close()
//        path.stroke()
        context.strokePath()
    }
    
    fileprivate static func pointFromNode(_ node: FoliageNode) -> CGPoint {
        return CGPoint(x: node.positionVector.x, y: node.positionVector.y)
    }
}
