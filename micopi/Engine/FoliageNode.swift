class FoliageNode {
    
    fileprivate(set) var x: Float
    fileprivate(set) var y: Float
    var nextNode: Node?
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    func applyForce(_ force: Float, angle: Float) {
        x += cosf(angle) * force
        y += sinf(angle) * force
    }
//    fileprivate func cgX() -> CGFloat {
//        return CGFloat(x)
//    }
//
//    fileprivate func cgY() -> CGFloat {
//        return CGFloat(y)
//    }
//
//    fileprivate func point() -> CGPoint {
//        return CGPoint(x: cgX(), y: cgY())
//    }
}
