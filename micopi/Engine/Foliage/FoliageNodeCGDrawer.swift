import CoreGraphics

class FoliageNodeCGDrawer: NSObject {
    
    weak var context: CGContext!
    @IBOutlet var colorConverter: ARGBColorCGConverter!
    
    func startLine(
        firstNode: FoliageNode,
        gray: Double = 1.0,
        alpha: Double = 0.5
    ) {
        context.setLineWidth(2)
        context.setStrokeColor(gray: CGFloat(gray), alpha: CGFloat(alpha))
        context.move(to: FoliageNodeCGDrawer.pointFromNode(firstNode))
    }
    
    func addNodeToLine(node: FoliageNode) {
        context.addLine(to: FoliageNodeCGDrawer.pointFromNode(node))
    }
    
    func closeAndDrawLine() {
        context.strokePath()
    }
    
    fileprivate static func pointFromNode(_ node: FoliageNode) -> CGPoint {
        return CGPoint(x: node.positionVector.x, y: node.positionVector.y)
    }
}
