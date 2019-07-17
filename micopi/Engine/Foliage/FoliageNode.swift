class FoliageNode {
    
    var x: Double
    var y: Double
    var nextNode: FoliageNode?
    var color: ARGBColor
    
    init(x: Double, y: Double, color: ARGBColor) {
        self.x = x
        self.y = y
        self.color = color
    }
    
}
