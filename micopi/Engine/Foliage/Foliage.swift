import CoreGraphics

class Foliage: NSObject {
    
    fileprivate var firstNode = FoliageNode(
        x: 0.0,
        y: 0.0,
        color: ARGBColor.black
    )
    fileprivate var age = 0
    fileprivate var maxAge = 256
    fileprivate var maxNewNodes = 32
    fileprivate var pushForce = Double(32)
    fileprivate var stopped = false
    fileprivate var nodeSize: Double {
        didSet {
            nodeRadius = nodeSize / 2.0
        }
    }
    fileprivate var nodeRadius: Double = 0.0 {
        didSet {
//            maxCircleShapeSize = CGFloat(nodeRadius * 36.0)
            neighborGravity = nodeRadius / 2
        }
    }
    fileprivate var neighborGravity: Double = 16.0
    fileprivate var preferredNeighborDistance: Double = 1 {
        didSet {
            preferredNeighborDistanceHalf = preferredNeighborDistance / 2.0
        }
    }
    fileprivate let numberOfInitialNodes: Int
    fileprivate var density: Int
    fileprivate var preferredNeighborDistanceHalf: Double = 0.0
    fileprivate var maxPushDistance: Double
    fileprivate var jitter: Double
    fileprivate var mirrored: Bool
    fileprivate var drawRects: Bool
    fileprivate let colorPalette: ARGBColorPalette
    fileprivate var nextColor: ARGBColor {
        get {
            return colorPalette.color(randomNumberGenerator: randomGenerator)
        }
    }
    var randomGenerator: RandomNumberGenerator = RandomNumberGenerator()
    var calculator: Calculator = Calculator()
    
    
    init(
        imageSize: Double,
        colorPalette: ARGBColorPalette,
        mirroredMode: Bool
    ) {
        self.mirrored = mirroredMode
        self.drawRects = !mirroredMode && false
        self.colorPalette = colorPalette
        
        nodeSize = imageSize / 300
        maxPushDistance = imageSize * 0.2
        jitter = imageSize * 0.001
        numberOfInitialNodes = randomGenerator.i(
            largerThan: 36,
            smallerThan: 64
        )
        density = numberOfInitialNodes
            / randomGenerator.i(largerThan: 4, smallerThan: 8)
        
        super.init()
        initNodes(imageSize: imageSize)
    }
    
    fileprivate func initNodes(imageSize: Double) {
        let shapeCenterX = imageSize / 2
        let shapeCenterY = imageSize / 2
        
        initNodes(
            inCircleAtX: shapeCenterX,
            atY: shapeCenterY,
            imageSize: imageSize
        )
    }
    
    fileprivate func initNodes(
        inCircleAtX x: Double,
        atY y: Double,
        imageSize: Double
    ) {
        let initialRadius = randomGenerator.d(
            greater: imageSize * 0.02,
            smaller: imageSize * 0.07
        )
        
        let slimnessFactor = randomGenerator.d(greater: 0.01, smaller: 2)
        
        var previousNode: FoliageNode!
        var firstNodeIsSet = false
        for i in 0 ..< numberOfInitialNodes {
            
            let angleOfNode = calculator.distributedAngleOnCircle(
                elementIndex: i + 1,
                numberOfElements: numberOfInitialNodes
            )
            
            let nodeX = x + (slimnessFactor * cos(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sin(angleOfNode) * initialRadius) + jitterValue()
            let node = FoliageNode(x: nodeX, y: nodeY, color: nextColor)
            
            if !firstNodeIsSet {
                firstNode = node
                previousNode = node
                firstNodeIsSet = true
            } else if i == numberOfInitialNodes - 1 {
                preferredNeighborDistance = 2.0 * calculator.distanceBetween(
                    node1: node,
                    node2: previousNode
                )
                previousNode.nextNode = node
                node.nextNode = firstNode
            } else {
                previousNode.nextNode = node
                previousNode = node
            }
            
        }
    }
    
    func updateAndDraw(
        nodeDrawer: FoliageNodeCGDrawer,
        context: CGContext
    ) -> Bool {
        age += 1
        stopped = false
        
        var nodeCounter = 0
        
        //        let path = UIBezierPath()
        //        path.move(to: firstNode.point())
        
        var currentNode = firstNode
        var numberOfNewNodes = 0
        repeat {
            nodeCounter += 1
            
            nodeDrawer.drawNode(currentNode, nextNode: currentNode.nextNode!, inContext: context)
            
            if numberOfNewNodes < maxNewNodes && nodeCounter % density == 0 {
                addNodeNextTo(node1: currentNode)
                numberOfNewNodes += 1
            }
            
            guard let nextNode = currentNode.nextNode else {
                break
            }
            
            updateNode(currentNode)
            
            currentNode = nextNode
        } while !stopped && currentNode !== firstNode
        
        return age < maxAge
    }
    
    fileprivate func addNodeNextTo(node1: FoliageNode) {
        guard let node3 = node1.nextNode else {
            return
        }
        
        let node2X = (node1.x + node3.x) * 0.5
        let node2Y = (node1.y + node3.y) * 0.5
        let node2 = FoliageNode(x: node2X, y: node2Y, color: nextColor)
        
        node1.nextNode = node2
        node2.nextNode = node3
    }
    
    fileprivate func jitterValue() -> Double {
        return (jitter * 0.5) - randomGenerator.d(greater: 0.0, smaller: jitter)
    }
    
    fileprivate func updateNode(_ currentNode: FoliageNode) {
        currentNode.x += jitterValue()
        currentNode.y += jitterValue()
        
        var otherNode = currentNode
        
        repeat {
            
            guard let nextNode = otherNode.nextNode,
                nextNode !== firstNode
            else {
                return
            }
            
            otherNode = nextNode
            
            let distance = calculator.distanceBetween(
                node1: currentNode,
                node2: otherNode
            )
            
            if distance > maxPushDistance {
                break
            }
            
            let force: Double
            if otherNode === currentNode.nextNode {
                if distance > preferredNeighborDistance {
                    force = -preferredNeighborDistanceHalf
                } else {
                    force = neighborGravity
                }
            } else {
                if distance < nodeRadius {
                    force = -nodeRadius
                } else {
                    force = pushForce / distance
                }
            }
            
            let angle = calculator.angleBetween(
                node1: currentNode,
                node2: otherNode
            )
            calculator.applyForceToNode(currentNode, force: force, angle: angle)
            
        } while !stopped
    }
}
