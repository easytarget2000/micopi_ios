import CoreGraphics

class Foliage {
    
    fileprivate var firstNode: FoliageNode!
    fileprivate var age = 0
    fileprivate var maxAge = 50
    fileprivate var maxNewNodes = 20
    fileprivate var pushForce = Float(8)
    fileprivate var stopped = false
    fileprivate var nodeSize: Float {
        didSet {
            nodeRadius = nodeSize / 2
        }
    }
    fileprivate var nodeRadius: Float {
        didSet {
            maxCircleShapeSize = CGFloat(nodeRadius) * CGFloat(36)
        }
    }
    fileprivate var neighborGravity: Float
    fileprivate var preferredNeighborDistance: Float = 1 {
        didSet {
            preferredNeighborDistanceHalf = preferredNeighborDistance / 2
        }
    }
    fileprivate var preferredNeighborDistanceHalf: Float
    fileprivate var maxPushDistance: Float
    fileprivate var jitter: Float
    fileprivate var maxCircleShapeSize: CGFloat
    fileprivate var mirrored: Bool
    fileprivate var drawRects: Bool
    fileprivate var shape = 0
    var randomGenerator: RandomCGNumberGenerator = RandomCGNumberGenerator()
    var calculator: Calculator = Calculator()
    
    fileprivate lazy var density: Int = {
        return self.numberOfInitialNodes / randomGenerator.i(largerThan: 4, smallerThan: 8)
        //       return Foliage.maxNewNodes / randomGenerator.i(largerThan: 3, smallerThan: 12)
    }()
    
    init(imageSize: Float, mirroredMode: Bool) {
        self.mirrored = mirroredMode
        self.drawRects = !mirroredMode && false
        
        nodeSize = imageSize / 300
        neighborGravity = nodeRadius / 2
        maxPushDistance = imageSize * 0.2
        jitter = imageSize * 0.001
        
    }
    
    func start(inCircleAtX x: Float, atY y: Float, imageSize: Float) {
        let numberOfInitialNodes = randomGenerator.i(
            largerThan: 36,
            smallerThan: 64
        )
        let initialRadius = randomGenerator.f(
            greater: imageSize * 0.02,
            smaller: imageSize * 0.07
        )
        
        let slimnessFactor = randomGenerator.f(greater: 0.01, smaller: 2)
        
        var lastNode: FoliageNode!
        for i in 0 ..< numberOfInitialNodes {
            
            let angleOfNode = piTwo * (Float((i + 1)) / Float(numberOfInitialNodes))
            
            let nodeX = x + (slimnessFactor * cosf(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sinf(angleOfNode) * initialRadius) + jitterValue()
            let node = FoliageNode(x: nodeX, y: nodeY)
            
            if firstNode == nil {
                firstNode = node
                lastNode = node
            } else if i == numberOfInitialNodes - 1 {
                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
                lastNode.nextNode = node
                node.next = firstNode
            } else {
                lastNode.nextNode = node
                lastNode = node
            }
            
        }
    }
    
//    func start(inPolygonAroundX x: Float, y: Float) {
//        let size = randomGenerator.f(greater: imageSize * 0.01, smaller: imageSize * 0.07)
//
//        let numberOfEdges = randomGenerator.i(greater: 3, smaller: 8)
//        //        let numberOfEdges = 4
//        let numberOfEdgesF = Float(numberOfEdges)
//        let nodesPerEdge = numberOfInitialNodes / numberOfEdges
//        let nodesPerEdgeF = Float(nodesPerEdge)
//
//        let angleOffset = randomGenerator.f(smaller: piTwo)
//
//        var lastNode: Node!
//        for i in 0 ..< numberOfInitialNodes {
//
//            let edge = i / nodesPerEdge
//            let edgeF = Float(edge)
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
//            let nodeRelativeToEdge1 = (Float(i) - (edgeF * nodesPerEdgeF)) / nodesPerEdgeF
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
    
    func updateAndDraw(
        nodeDrawer: FoliageNodeDrawer
    ) -> Bool {
        age += 1
        stopped = false
        
        var nodeCounter = 0
        
        context.setLineWidth(1)
        context.setStrokeColor(color1)
        
        //        let path = UIBezierPath()
        //        path.move(to: firstNode.point())
        
        var currentNode = firstNode!
        var numberOfNewNodes = 0
        repeat {
            nodeCounter += 1
            
            nodeDrawer.drawNode(currentNode)
            
            if numberOfNewNodes < maxNewNodes && nodeCounter % density == 0 {
                add(nodeNextTo: currentNode)
                numberOfNewNodes += 1
            }
            
//            guard let nextNode = node.nextNode else {
//                break
//            }
            
            update(node: currentNode)
            
            currentNode = nextNode
        } while !stopped && currentNode !== firstNode
        
        return age < maxAge
    }
    
    fileprivate func add(nodeNextTo node1: FoliageNode) {
        guard let node3 = node1.nextNode else {
            return
        }
        
        let node2X = (node1.x + node3.x) * 0.5
        let node2Y = (node1.y + node3.y) * 0.5
        let node2 = FoliageNode(x: node2X, y: node2Y)
        
        node1.next = node2
        node2.next = node3
    }
    
    fileprivate func jitterValue() -> Float {
        return (jitter * 0.5) - randomGenerator.f(smallerThan: jitter)
    }
    
    fileprivate func update(node currentNode: FoliageNode) {
        currentNode.applyForce(jitterValue(), angle: jitterValue())
        
        var otherNode = currentNode
        
        repeat {
            
            guard let nextNode = otherNode.nextNode,
                nextNode !== firstNode
            else {
                return
            }
            
            otherNode = nextNode
            
            let distance = Foliage.distanceBetween(
                node1: currentNode,
                node2: otherNode
            )
            
            if distance > maxPushDistance {
                break
            }
            
            let force: Float
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
            
            let angle = Foliage.angleBetween(
                node1: currentNode,
                node2: otherNode
            )
            currentNode.applyForce(force, angle: angle)
            
        } while !stopped
    }
}