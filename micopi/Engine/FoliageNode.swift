class FoliageNode {
    
    fileprivate(set) var x: Float
    fileprivate(set) var y: Float
    var nextNode: FoliageNode?
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    func applyForce(_ force: Float, angle: Float) {
        x += cosf(angle) * force
        y += sinf(angle) * force
    }
}
