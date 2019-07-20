import CoreGraphics

class Foliage {
    
    let maxJitter: Double
    var firstNode: FoliageNode!
    var worldSize: Double
    var age = 0
    let maxAge = 1024 * 32
    var totalNodeCounter = 0
    var maxNumOfNodesAddedPerRound = 2 // 4
    var maxNumOfTotalNodes = 256
    var nodeAddCounter = 0
    var nodeDensity: Int
    var stopped = false
    var addNodes = false
    var lineGray = 1.0
    var lineAlpha = 0.2
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
    
    func stop() {
        self.stopped = true
    }
    
    func updateAndDraw(
        nodeDrawer: FoliageNodeCGDrawer,
        invertMovement: Bool = false
    ) -> Bool {
        age += 1
        guard age < maxAge else {
            return false
        }
        
        var currentNode: FoliageNode!
        var nodeCounter = 0
        adjustColor()
        
        repeat {
            
            if let currentNode = currentNode {
                nodeDrawer.addNodeToLine(node: currentNode)
            } else {
                currentNode = firstNode
                nodeDrawer.startLine(
                    firstNode: firstNode,
                    gray: lineGray,
                    alpha: lineAlpha
                )
            }
            
            guard let nextNode = currentNode?.next else {
                return true
            }

            currentNode.update(invertMovement: invertMovement)
            
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
        
        nodeDrawer.closeAndDrawLine()
        nodeAddCounter = 0
        return true
    }
    
    fileprivate func adjustColor() {
        let maxColorStep = 0.05
        lineGray += randomNumberGenerator.d(
            greater: -maxColorStep,
            smaller: maxColorStep
        )
        if lineGray < 0 {
            lineGray = 0
        } else if lineGray > 1 {
            lineGray = 1
        }
    }
    
    fileprivate func addNodeNextTo(node: FoliageNode) {
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
