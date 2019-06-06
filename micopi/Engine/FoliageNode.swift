class FoliageNode {
    
    fileprivate var x: Float
    fileprivate var y: Float
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    fileprivate func cgX() -> CGFloat {
        return CGFloat(x)
    }
    
    fileprivate func cgY() -> CGFloat {
        return CGFloat(y)
    }
    
    fileprivate func point() -> CGPoint {
        return CGPoint(x: cgX(), y: cgY())
    }
    
    fileprivate func distance(toOtherNode otherNode: Node) -> Float {
        return sqrtf(pow(otherNode.x - x, 2) + pow(otherNode.y - y, 2))
    }
}
