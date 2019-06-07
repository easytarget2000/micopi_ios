import CoreGraphics

class Foliage {
    
    fileprivate var firstNode: FoliageNode!
    fileprivate var age = 0
    fileprivate var maxAge = 50
    fileprivate var maxNewNodes = 20
    fileprivate var pushForce = Double(8)
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
    fileprivate var neighborGravity: Double = 0.0
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
    fileprivate var shape = 0
    var randomGenerator: RandomCGNumberGenerator = RandomCGNumberGenerator()
    var calculator: Calculator = Calculator()
    
    
    init(imageSize: Double, mirroredMode: Bool) {
        self.mirrored = mirroredMode
        self.drawRects = !mirroredMode && false
        
        nodeSize = imageSize / 300
        maxPushDistance = imageSize * 0.2
        jitter = imageSize * 0.001
        numberOfInitialNodes = randomGenerator.i(
            largerThan: 36,
            smallerThan: 64
        )
        density = numberOfInitialNodes
            / randomGenerator.i(largerThan: 4, smallerThan: 8)
    }
    
    func start(inCircleAtX x: Double, atY y: Double, imageSize: Double) {
        let initialRadius = randomGenerator.d(
            greater: imageSize * 0.02,
            smaller: imageSize * 0.07
        )
        
        let slimnessFactor = randomGenerator.d(greater: 0.01, smaller: 2)
        
        var lastNode: FoliageNode!
        for i in 0 ..< numberOfInitialNodes {
            
            let angleOfNode = calculator.distributedAngleOnCircle(
                elementIndex: i + 1,
                numberOfElements: numberOfInitialNodes
            )
            
            let nodeX = x + (slimnessFactor * cos(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sin(angleOfNode) * initialRadius) + jitterValue()
            let node = FoliageNode(x: nodeX, y: nodeY)
            
            if firstNode == nil {
                firstNode = node
                lastNode = node
            } else if i == numberOfInitialNodes - 1 {
                preferredNeighborDistance = calculator.distanceBetween(
                    node1: node,
                    node2: lastNode
                )
                lastNode.nextNode = node
                node.nextNode = firstNode
            } else {
                lastNode.nextNode = node
                lastNode = node
            }
            
        }
    }
    
//    func start(inPolygonAroundX x: Double, y: Double) {
//        let size = randomGenerator.d(greater: imageSize * 0.01, smaller: imageSize * 0.07)
//
//        let numberOfEdges = randomGenerator.i(greater: 3, smaller: 8)
//        //        let numberOfEdges = 4
//        let numberOfEdgesF = Double(numberOfEdges)
//        let nodesPerEdge = numberOfInitialNodes / numberOfEdges
//        let nodesPerEdgeF = Double(nodesPerEdge)
//
//        let angleOffset = randomGenerator.d(smaller: piTwo)
//
//        var lastNode: Node!
//        for i in 0 ..< numberOfInitialNodes {
//
//            let edge = i / nodesPerEdge
//            let edgeF = Double(edge)
//            let angleOfEdge1 = angleOffset + (piTwo * edgeF / numberOfEdgesF)
//            let angleOfEdge2 = angleOffset + (piTwo * (edgeF + 1) / numberOfEdgesF)
//
//            let edge1X = x + (size * cosf(angleOfEdge1))
//            let edge1Y = y + (size * sinf(angleOfEdge1))
//
//            let edge2X = x + (size * cosf(angleOfEdge2))
//            let edge2Y = y + (size * sinf(angleOfEdge2))
//
//            //            print("Edge 1: \(edge1X), \(edge1Y)")
//            //            print("Edge 2: \(edge2X), \(edge2Y)")
//
//            let angleBetweenEdges = Foliage.angle(
//                betweenX1: edge1X,
//                y1: edge1Y,
//                x2: edge2X,
//                y2: edge2Y
//            )
//            let nodeRelativeToEdge1 = (Double(i) - (edgeF * nodesPerEdgeF)) / nodesPerEdgeF
//
//            //            print("i: \(i), edge: \(edge), angleBetweenEdges: \(angleBetweenEdges), nodeRelTo1: \(nodeRelativeToEdge1)")
//
//            //            final double edge = i / nodesPerEdge;
//            //            final double angleOfEdge1 = polygonAngle + (TWO_PI * edge / numberOfEdges);
//            //            final double angleOfEdge2 = polygonAngle + (TWO_PI * (edge + 1) / numberOfEdges);
//            //
//            //            final double edge1X = x + (size * Math.cos(angleOfEdge1));
//            //            final double edge1Y = y + (size * Math.sin(angleOfEdge1));
//            //
//            //            final double edge2X = x + (size * Math.cos(angleOfEdge2));
//            //            final double edge2Y = y + (size * Math.sin(angleOfEdge2));
//            //
//            //            //            Log.d(TAG, "Edge 1: " + edge1X + ", " + edge1Y);
//            //            //            Log.d(TAG, "Edge 2: " + edge2X + ", " + edge2Y);
//            //
//            //            final double angleBetweenEdges = angle(edge1X, edge1Y, edge2X, edge2Y);
//            //            final double nodeRelativeToEdge1 = (i  - (edge * (double) nodesPerEdge)) / (double) nodesPerEdge;
//            //            //            Log.d(TAG, "i: " + i + ", edge: " + edge + ", angleBetweenEdges: " + angleBetweenEdges + ", nodeRelativeToEdge1: " + nodeRelativeToEdge1);
//            //
//            //            final Node node = new Node();
//            //            node.mX = edge1X + (Math.cos(angleBetweenEdges) * nodeRelativeToEdge1 * size);
//            //            node.mY = edge1Y + (Math.sin(angleBetweenEdges) * nodeRelativeToEdge1 * size);
//
//            let node = Node(
//                x: edge1X + (cosf(angleBetweenEdges) * nodeRelativeToEdge1 * size),
//                y: edge1Y + (sinf(angleBetweenEdges) * nodeRelativeToEdge1 * size)
//            )
//
//            if firstNode == nil {
//                firstNode = node
//                lastNode = node
//            } else if i == numberOfInitialNodes - 1 {
//                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
//                lastNode.next = node
//                node.next = firstNode
//            } else {
//                lastNode.next = node
//                lastNode = node
//            }
//
//        }
//    }
    
    func updateAndDraw(nodeDrawer: FoliageNodeCGDrawer) -> Bool {
        age += 1
        stopped = false
        
        var nodeCounter = 0
        
        //        let path = UIBezierPath()
        //        path.move(to: firstNode.point())
        
        var currentNode = firstNode!
        var numberOfNewNodes = 0
        repeat {
            nodeCounter += 1
            
            nodeDrawer.drawNode(currentNode, nextNode: currentNode.nextNode!)
            
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
        let node2 = FoliageNode(x: node2X, y: node2Y)
        
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
