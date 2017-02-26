//
//  Foliage.swift
//  micopi
//
//  Created by Michel Sievers on 25/02/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import CoreGraphics

class Foliage {
    
    fileprivate static let numberOfInitialNodes = 40
    
    fileprivate static let maxAge = 64
    
    fileprivate static let maxNewNodes = 128
    
    fileprivate static let pushForce = Float(16)
    
    fileprivate static let piTwo = Float(M_PI_2)
    
    fileprivate var imageSize: Float
    
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
    
    fileprivate var preferredNeighborDistance: Float = 16
    
    fileprivate lazy var maxPushDistance: Float = {
        return self.imageSize * 0.1
    }()

    fileprivate lazy var jitter: Float = {
        return self.imageSize * 0.001
    }()
    
    fileprivate var mirrored: Bool
    
    fileprivate var drawRects: Bool
    
    fileprivate var age = 0
    
    fileprivate var density = 40
    
    fileprivate var firstNode: Node!
    
    init(imageSize: Float, mirroredMode: Bool) {
        self.imageSize = imageSize
        self.mirrored = mirroredMode
        self.drawRects = !mirroredMode && false //
    }
    
    func start(inCircleAtX x: Float, atY y: Float) {
        let initialRadius = imageSize * 0.05

        var lastNode: Node!
        for i in 0 ..< Foliage.numberOfInitialNodes {
            
            let angleOfNode = Foliage.piTwo * Float((i + 1) / Foliage.numberOfInitialNodes)
            
            let nodeX = x + (cosf(angleOfNode) * initialRadius) + jitterValue()
            let nodeY = y + (sinf(angleOfNode) * initialRadius) + jitterValue()
            let node = Node(x: nodeX, y: nodeY)
            
            if firstNode == nil {
                self.firstNode = node
            } else if i == Foliage.numberOfInitialNodes - 1 {
                self.preferredNeighborDistance = node.distance(toOtherNode: lastNode)
            } else {
                lastNode.next = node
                lastNode = node
            }
            
        }
    }
    
    func updateAndDraw(inContext context: CGContext) {
        age += 1
        stopped = false
        
        var nodeCounter = 0
        
        context.move(to: firstNode.point())
        var currentNode = firstNode!
        repeat {
            guard let nextNode = currentNode.next else {
                return
            }
            
            currentNode = nextNode
            
            context.addLine(to: currentNode.point())
            
            // Update;
            
            nodeCounter += 1
            if nodeCounter < Foliage.maxNewNodes && nodeCounter % density == 0 {
                add(nodeNextTo: currentNode)
            }
            
            
        } while !stopped && currentNode !== firstNode
        
        context.drawPath(using: CGPathDrawingMode.stroke)
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
        return 0
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
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        
        fileprivate func update() {
            
        }
        
        fileprivate func distance(toOtherNode otherNode: Node) -> Float {
            return sqrtf(pow(otherNode.x - x, 2) + pow(otherNode.y - y, 2))
        }
        
        fileprivate func angle(toOtherNode otherNode: Node) -> Float {
            let angle = atan2f(-(otherNode.y - y), otherNode.x - x)
            if angle < 0 {
                return angle + Foliage.piTwo
            } else {
                return angle
            }
        }
    }
    
}
