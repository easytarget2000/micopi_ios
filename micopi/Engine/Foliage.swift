//
//  Foliage.swift
//  micopi
//
//  Created by Michel Sievers on 25/02/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import CoreGraphics
import UIKit

class Foliage {
    
    
    fileprivate static let maxAge = 48
    
    fileprivate static let maxNewNodes = 16
    
    fileprivate static let pushForce = Float(8)
    
    fileprivate let numberOfInitialNodes = Random.i(largerThan: 36, smallerThan: 64)
    
    fileprivate var imageSize: Float
    
    fileprivate lazy var cgImageSize: CGFloat = {
        return CGFloat(self.imageSize)
    }()
    
    fileprivate var stopped = false
    
    fileprivate lazy var nodeSize: Float = {
        return self.imageSize / 300
    }()
    
    fileprivate lazy var nodeRadius: Float = {
       return self.nodeSize * 0.5
    }()

    fileprivate lazy var neighborGravity: Float = {
       return self.nodeRadius * 0.5
    }()
    
    fileprivate var preferredNeighborDistance: Float = 1
    
    fileprivate lazy var preferredNeighborDistanceHalf: Float = {
       return self.preferredNeighborDistance * 0.5
    }()
    
    fileprivate lazy var maxPushDistance: Float = {
        return self.imageSize * 0.2
    }()

    fileprivate lazy var jitter: Float = {
        return self.imageSize * 0.001
    }()
    
    fileprivate lazy var shape: Int = {
        return 0
//        return Random.i(smallerThan: 2)
    }()
    
    fileprivate lazy var maxCircleShapeSize: CGFloat = {
        return CGFloat(self.nodeRadius * 36)
    }()
    
    fileprivate var mirrored: Bool
    
    fileprivate var drawRects: Bool
    
    fileprivate var age = 0
    
    fileprivate lazy var density: Int = {
        return self.numberOfInitialNodes / Random.i(largerThan: 4, smallerThan: 8)
//       return Foliage.maxNewNodes / Random.i(largerThan: 3, smallerThan: 12)
    }()
    
    fileprivate var firstNode: Node!
    
    init(imageSize: Float, mirroredMode: Bool) {
        self.imageSize = imageSize
        self.mirrored = mirroredMode
        self.drawRects = !mirroredMode && false
        
        #if DEBUG
            NSLog("Foliage: DEBUG: Image size: \(imageSize)")
            NSLog("Foliage: DEBUG: Density: \(density)")
        #endif
    }
    
    func start(inCircleAtX x: Float, atY y: Float) {
        let initialRadius = Random.f(greater: imageSize * 0.02, smaller: imageSize * 0.07)
        
        let slimnessFactor = Random.f(greater: 0.01, smaller: 2)
        
        var lastNode: Node!
        for i in 0 ..< numberOfInitialNodes {
            
            let angleOfNode = piTwo * (Float((i + 1)) / Float(numberOfInitialNodes))
            
            let nodeX = x + (slimnessFactor * cosf(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sinf(angleOfNode) * initialRadius) + jitterValue()
            let node = Node(x: nodeX, y: nodeY)
            
            if firstNode == nil {
                firstNode = node
                lastNode = node
            } else if i == numberOfInitialNodes - 1 {
                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
                lastNode.next = node
                node.next = firstNode
            } else {
                lastNode.next = node
                lastNode = node
            }
            
        }
    }
    
    func start(inPolygonAroundX x: Float, y: Float) {
        let size = Random.f(greater: imageSize * 0.01, smaller: imageSize * 0.07)
        
        let numberOfEdges = Random.i(greater: 3, smaller: 8)
//        let numberOfEdges = 4
        let numberOfEdgesF = Float(numberOfEdges)
        let nodesPerEdge = numberOfInitialNodes / numberOfEdges
        let nodesPerEdgeF = Float(nodesPerEdge)
        
        let angleOffset = Random.f(smaller: piTwo)
        
        var lastNode: Node!
        for i in 0 ..< numberOfInitialNodes {
            
            let edge = i / nodesPerEdge
            let edgeF = Float(edge)
            let angleOfEdge1 = angleOffset + (piTwo * edgeF / numberOfEdgesF)
            let angleOfEdge2 = angleOffset + (piTwo * (edgeF + 1) / numberOfEdgesF)
            
            let edge1X = x + (size * cosf(angleOfEdge1))
            let edge1Y = y + (size * sinf(angleOfEdge1))
            
            let edge2X = x + (size * cosf(angleOfEdge2))
            let edge2Y = y + (size * sinf(angleOfEdge2))
            
//            print("Edge 1: \(edge1X), \(edge1Y)")
//            print("Edge 2: \(edge2X), \(edge2Y)")
            
            let angleBetweenEdges = Foliage.angle(
                betweenX1: edge1X,
                y1: edge1Y,
                x2: edge2X,
                y2: edge2Y
            )
            let nodeRelativeToEdge1 = (Float(i) - (edgeF * nodesPerEdgeF)) / nodesPerEdgeF
            
//            print("i: \(i), edge: \(edge), angleBetweenEdges: \(angleBetweenEdges), nodeRelTo1: \(nodeRelativeToEdge1)")
            
//            final double edge = i / nodesPerEdge;
//            final double angleOfEdge1 = polygonAngle + (TWO_PI * edge / numberOfEdges);
//            final double angleOfEdge2 = polygonAngle + (TWO_PI * (edge + 1) / numberOfEdges);
//            
//            final double edge1X = x + (size * Math.cos(angleOfEdge1));
//            final double edge1Y = y + (size * Math.sin(angleOfEdge1));
//            
//            final double edge2X = x + (size * Math.cos(angleOfEdge2));
//            final double edge2Y = y + (size * Math.sin(angleOfEdge2));
//            
//            //            Log.d(TAG, "Edge 1: " + edge1X + ", " + edge1Y);
//            //            Log.d(TAG, "Edge 2: " + edge2X + ", " + edge2Y);
//            
//            final double angleBetweenEdges = angle(edge1X, edge1Y, edge2X, edge2Y);
//            final double nodeRelativeToEdge1 = (i  - (edge * (double) nodesPerEdge)) / (double) nodesPerEdge;
//            //            Log.d(TAG, "i: " + i + ", edge: " + edge + ", angleBetweenEdges: " + angleBetweenEdges + ", nodeRelativeToEdge1: " + nodeRelativeToEdge1);
//            
//            final Node node = new Node();
//            node.mX = edge1X + (Math.cos(angleBetweenEdges) * nodeRelativeToEdge1 * size);
//            node.mY = edge1Y + (Math.sin(angleBetweenEdges) * nodeRelativeToEdge1 * size);
            
            let node = Node(
                x: edge1X + (cosf(angleBetweenEdges) * nodeRelativeToEdge1 * size),
                y: edge1Y + (sinf(angleBetweenEdges) * nodeRelativeToEdge1 * size)
            )
            
            if firstNode == nil {
                firstNode = node
                lastNode = node
            } else if i == numberOfInitialNodes - 1 {
                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
                lastNode.next = node
                node.next = firstNode
            } else {
                lastNode.next = node
                lastNode = node
            }
            
        }
    }
    
    func updateAndDraw(inContext context: CGContext, withColor1 color1: CGColor, color2: CGColor) -> Bool {
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
            
            if shape == 1 {
                context.setStrokeColor(color2)
                context.strokeEllipse(
                    in: CGRect(
                        x: currentNode.cgX() + 1,
                        y: currentNode.cgY() + 1,
                        width: Random.cgF(smallerThan: maxCircleShapeSize),
                        height: Random.cgF(smallerThan: maxCircleShapeSize)
                    )
                )
            } else {
                context.setFillColor(color2)
                context.fill(
                    CGRect(
                        x: currentNode.cgX() + 1,
                        y: currentNode.cgY() + 1,
                        width: 1,
                        height: 1
                    )
                )
            }
            
            if mirrored {
                if shape == 1 {
                    context.setStrokeColor(color2)
                    context.strokeEllipse(
                        in: CGRect(
                            x: currentNode.cgX() + 1,
                            y: currentNode.cgY() + 1,
                            width: Random.cgF(smallerThan: maxCircleShapeSize),
                            height: Random.cgF(smallerThan: maxCircleShapeSize)
                        )
                    )
                } else {
                    context.setFillColor(color1)
                    context.fill(
                        CGRect(
                            x: cgImageSize - currentNode.cgX(),
                            y: currentNode.cgY(),
                            width: 1,
                            height: 1
                        )
                    )
                }
            } else {
                context.beginPath()
                context.move(to: currentNode.point())
            }
            
            guard let nextNode = currentNode.next else {
                break
            }
            
            if !mirrored {
                context.addLine(to: nextNode.point())
                context.closePath()
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            
            // Update:
            
            if numberOfNewNodes < Foliage.maxNewNodes && nodeCounter % density == 0 {
                add(nodeNextTo: currentNode)
                numberOfNewNodes += 1
            }
            
            update(node: currentNode)
            
            currentNode = nextNode
        } while !stopped && currentNode !== firstNode
        
        return age < Foliage.maxAge
    }
    
    fileprivate func add(nodeNextTo node1: Node) {
        guard let node3 = node1.next else {
            return
        }
        
        let node2X = (node1.x + node3.x) * 0.5
        let node2Y = (node1.y + node3.y) * 0.5
        let node2 = Node(x: node2X, y: node2Y)
        
        node1.next = node2
        node2.next = node3
    }
    
    fileprivate func jitterValue() -> Float {
        return (jitter * 0.5) - Random.f(smallerThan: jitter)
    }
    
    fileprivate func update(node currentNode: Node) {
        currentNode.x += jitterValue()
        currentNode.y += jitterValue()
        
        var otherNode = currentNode
        
        repeat {
            
            guard let nextNode = otherNode.next, nextNode !== firstNode else {
                return
            }
            
            otherNode = nextNode
            
            let distance = currentNode.distance(toOtherNode: otherNode)
            
            if distance > maxPushDistance {
                break
            }
            
            let force: Float
            if otherNode === currentNode.next {
                if distance > preferredNeighborDistance {
                    force = -preferredNeighborDistanceHalf
                } else {
                    force = neighborGravity
                }
            } else {
                
                if distance < nodeRadius {
                    force = -nodeRadius
                } else {
                    force = Foliage.pushForce / distance
                }
            }
            
//            let angle = currentNode.angle(toOtherNode: otherNode)
            let angle = Foliage.angle(betweenNode: currentNode, node2: otherNode)
            
            currentNode.x += cosf(angle) * force
            currentNode.y += sinf(angle) * force
            
        } while !stopped
    }
    
    fileprivate static func angle(betweenNode node1: Node, node2: Node) -> Float {
        return Foliage.angle(betweenX1: node1.x, y1: node1.y, x2: node2.x, y2: node2.y)
    }
    
    fileprivate static func angle(betweenX1 x1: Float, y1: Float, x2: Float, y2: Float) -> Float {
        return atan2f(y2 - y1, x2 - x1) + pi
    }
        
    class Node {
        
        fileprivate var next: Node?
        
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
        
//        fileprivate func angle(toOtherNode otherNode: Node) -> Float {
//            return atan2f(otherNode.y - y, otherNode.x - x) + Foliage.pi
//        }
        

    }
    
}
