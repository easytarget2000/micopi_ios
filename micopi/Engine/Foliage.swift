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
    
    fileprivate static let numberOfInitialNodes = Int(drand48() * 24) + 24
    
    fileprivate static let maxAge = 48
    
    fileprivate static let maxNewNodes = 32
    
    fileprivate static let pushForce = Float(2)
    
    fileprivate static let pi = Float(M_PI)
    
    fileprivate static let piTwo = pi * 2
    
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
       return self.nodeRadius * 0.2
    }()
    
    fileprivate var preferredNeighborDistance: Float = 1
    
    fileprivate lazy var preferredNeighborDistanceHalf: Float = {
       return self.preferredNeighborDistance * 0.5
    }()
    
    fileprivate lazy var maxPushDistance: Float = {
        return self.imageSize * 0.5
    }()

    fileprivate lazy var jitter: Float = {
        return self.imageSize * 0.001
    }()
    
    fileprivate var mirrored: Bool
    
    fileprivate var drawRects: Bool
    
    fileprivate var age = 0
    
    fileprivate lazy var density: Int = {
       return Foliage.maxNewNodes / (Int(drand48() * 8.0) + 6)
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
        let initialRadius = imageSize * (Float(drand48() * 0.01) + 0.01)

        var lastNode: Node!
        for i in 0 ..< Foliage.numberOfInitialNodes {
            
            let angleOfNode = Foliage.piTwo * Float((i + 1)) / Float(Foliage.numberOfInitialNodes)
            
            let nodeX = x + (cosf(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sinf(angleOfNode) * initialRadius) + jitterValue()
            let node = Node(x: nodeX, y: nodeY)
            
            
            if firstNode == nil {
                self.firstNode = node
                lastNode = node
            } else if i == Foliage.numberOfInitialNodes - 1 {
                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
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
            
            context.setFillColor(color2)
            context.fill(
                CGRect(
                    x: currentNode.cgX(),
                    y: currentNode.cgY(),
                    width: 1,
                    height: 1
                )
            )
            
            if mirrored {
                context.setFillColor(color1)
                context.fill(
                    CGRect(
                        x: cgImageSize - currentNode.cgX(),
                        y: currentNode.cgY(),
                        width: 1,
                        height: 1
                    )
                )
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
        return (jitter * 0.5) - (Float(drand48()) * jitter)
    }
    
    fileprivate func update(node currentNode: Node) {
        currentNode.x += jitterValue()
        currentNode.y += jitterValue()
        
        var otherNode = currentNode
        
        repeat {
            
            guard let nextNode = otherNode.next, nextNode !== self else {
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
            
            let angle = currentNode.angle(toOtherNode: otherNode)
            
            currentNode.x += cosf(angle) * force
            currentNode.y += sinf(angle) * force
            
        } while !stopped
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
        
        fileprivate func angle(toOtherNode otherNode: Node) -> Float {
            return atan2f(otherNode.y - y, otherNode.x - x) + Foliage.pi
        }
        

    }
    
}
