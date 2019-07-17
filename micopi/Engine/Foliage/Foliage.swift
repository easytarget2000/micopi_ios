import CoreGraphics

class Foliage {
    
    let maxJitter: Double
    var firstNode: FoliageNode!
    var worldSize: Double
    var age = 0
    let maxAge = 1024 * 32
    var totalNodeCounter = 0
    var maxNumOfNodesAddedPerRound = 4
    var maxNumOfTotalNodes = 256
    var nodeAddCounter = 0
    var nodeDensity: Int
    var stopped = false
    var addNodes = false
    var randomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator()
    var jitter: Double {
        get {
            return randomNumberGenerator.d(
                greater: -maxJitter,
                smaller: maxJitter
            )
        }
    }
    
    init(
        worldSize: Double,
        numOfInitialNodes: Int,
        maxJitter: Double,
        startX: Double,
        startY: Double,
        radius: Double
    ) {
        self.worldSize = worldSize
        self.maxJitter = maxJitter
        
        nodeDensity = numOfInitialNodes / 16
        initCircle(
            numOfInitialNodes: numOfInitialNodes,
            startX: startX,
            startY: startY,
            radius: radius
        )
    }
    
    fileprivate func initCircle(
        numOfInitialNodes: Int,
        startX: Double,
        startY: Double,
        radius: Double
    ) {
        let circleCenterX = startX
        let circleCenterY = startY
        
        let minSqueezeFactorMin = 0.66
        let squeezeFactor = randomNumberGenerator.d(
            greater: minSqueezeFactorMin,
            smaller: minSqueezeFactorMin * 2.0
        )
        
        var lastNode: FoliageNode!
        for nodeIndex in 0 ..< numOfInitialNodes {
            let angleOfNode = Double.pi
                * ((Double(nodeIndex) + 1.0) / Double(numOfInitialNodes))
            let x = circleCenterX
                + ((cos(angleOfNode) * radius) * squeezeFactor)
                + jitter
            let y = circleCenterY
                + (sin(angleOfNode) * radius)
                + jitter
            
            let nodePosition = Vector2(x, y)
            let node = FoliageNode(
                positionVector: nodePosition,
                maxJitter: maxJitter,
                worldSize: worldSize
            )
            
            if firstNode == nil {
                firstNode = node
                lastNode = node
            } else if (nodeIndex == numOfInitialNodes - 1) {
                lastNode.next = node
                node.next = firstNode
            } else {
                lastNode.next = node
                lastNode = node
            }
        }
        
        totalNodeCounter += 1
    }
    
//    func drawIfAlive(color: ARGBColor, numOfRounds: Int = 1, drawOutline = true) {
//        if (age += 1 > maxAge) {
//            return false
//        }
//
//        noFill()
//        stroke(color_)
//        strokeWeight(1.0)
//
//        self.nodeAddCounter = 0
//
//        for (var i = 0 i < numOfRounds i++) {
//            self.drawAndUpdateNodes(drawOutline)
//        }
//
//        return true
//    }
    
    func stop() {
        self.stopped = true
    }
    
    func updateAndDraw(
        nodeDrawer: FoliageNodeCGDrawer,
        context: CGContext
    ) -> Bool {
        age += 1
        guard age < maxAge else {
            return false
        }
        
        var currentNode = firstNode!
        var nodeCounter = 0

        repeat {
            guard let nextNode = currentNode.next else {
                return true
            }

            currentNode.update()
            nodeDrawer.drawNode(
                currentNode,
                nextNode: nextNode,
                inContext: context
            )
            
            if addNodes,
                nodeAddCounter < maxNumOfNodesAddedPerRound,
                totalNodeCounter < maxNumOfTotalNodes,
                nodeCounter % nodeDensity == 0
            {
                addNodeNextTo(node: currentNode)
            }
            
            currentNode = nextNode
            nodeCounter += 1
        } while (!stopped && currentNode !== firstNode)
        
        return true
    }
    
    func addNodeNextTo(node: FoliageNode) {
        guard let oldNeighbour = node.next else {
            return
        }
        
        let newNeighbourPos = (node.positionVector + oldNeighbour.positionVector) * 0.5
//            .add()
//            .mult(0.5)
        
        let newNeighbour = FoliageNode(
            positionVector: newNeighbourPos,
            maxJitter: maxJitter,
            worldSize: worldSize
        )
        
        node.next = newNeighbour
        newNeighbour.next = oldNeighbour
        
        nodeAddCounter += 1
        totalNodeCounter += 1
    }
    
}
