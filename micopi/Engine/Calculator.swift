import CoreGraphics

struct Calculator {
    
    let piTwo = Double.pi * 2
    
    func applyForceToNode(_ node: FoliageNode, force: Double, angle: Double) {
        node.x += cos(angle) * force
        node.y += sin(angle) * force
    }
    
    func distanceBetween(
        node1: FoliageNode,
        node2: FoliageNode
    ) -> Double {
        return distanceBetween(
            x1: node1.x,
            y1: node1.y,
            x2: node2.x,
            y2: node2.y
        )
    }
    
    func angleBetween(
        node1: FoliageNode,
        node2: FoliageNode
    ) -> Double {
        return angleBetween(
            x1: node1.x,
            y1: node1.y,
            x2: node2.x,
            y2: node2.y
        )
    }
    
    func distanceBetween(
        x1: Double,
        y1: Double,
        x2: Double,
        y2: Double
    ) -> Double {
        return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
    }
    
    func angleBetween(
        x1: Double,
        y1: Double,
        x2: Double,
        y2: Double
    ) -> Double {
        return atan2(y2 - y1, x2 - x1) + .pi
    }
}
