struct Calculator {
    
    func distanceBetween(
        node1: FoliageNode,
        node2: FoliageNode
        ) -> Float {
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
        ) -> Float {
        return angleBetween(
            x1: node1.x,
            y1: node1.y,
            x2: node2.x,
            y2: node2.y
        )
    }
    
    func distanceBetween(
        x1: Float,
        y1: Float,
        x2: Float,
        y2: Float
        ) -> Float {
        return sqrtf(pow(x2 - x1, 2) + pow(y2 - y1, 2))
    }
    
    func angleBetween(
        x1: Float,
        y1: Float,
        x2: Float,
        y2: Float
    ) -> Float {
        return atan2f(y2 - y1, x2 - x1) + pi
    }
}
