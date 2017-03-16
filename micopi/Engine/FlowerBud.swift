//
//  FlowerBud.swift
//  micopi
//
//  Created by Michel Sievers on 16/03/2017.
//  Copyright © 2017 Easy Target. All rights reserved.
//

import UIKit

class FlowerBud {
    
    fileprivate var imageSize: Float
    
    fileprivate static let maxAge = 16
    
    fileprivate var sizeFactor: Float
    
    fileprivate var numberOfPetals: Int
    
    fileprivate var petals: [Petal]

    init(imageSize: Float, x: Float, y: Float) {
        self.imageSize = imageSize
        self.sizeFactor = Random.f(greater: 0.1, smaller: 0.7)
        
        let base = Double(self.sizeFactor)
        let exponent = Random.d(greater: 4, smaller: 10)
        self.numberOfPetals = Int(pow(base, exponent))
        
        self.petals = [Petal]()
        for i in 0 ..< numberOfPetals {
            self.petals[i] = Petal(
                maxLength: self.imageSize * self.sizeFactor,
                x: x,
                y: y,
                angle: piTwo * Float(i) / Float(self.numberOfPetals)
            )
        }
        
    }
    
    class Petal {
        
        fileprivate var finalLength: Float
        
        fileprivate var currentLength = Float(0)
        
        fileprivate lazy var maxNumberOfPods: Int = {
            return Random.i(greater: 3, smaller: 12)
        }()
        
        fileprivate var numberOfPods = 0
        
        fileprivate var angle: Float
        
        fileprivate var startX: Float
        
        fileprivate var startY: Float
        
        fileprivate var lastX: CGFloat
        
        fileprivate var lastY: CGFloat
        
        fileprivate lazy var endX: Float = {
            return self.startX + (cosf(self.angle) * self.finalLength)
        }()
        
        fileprivate lazy var endY: Float = {
           return self.startY + (sinf(self.angle) * self.finalLength)
        }()
        
        fileprivate init(maxLength: Float, x: Float, y: Float, angle: Float) {
            self.finalLength = Random.f(greater: maxLength * 0.9, smaller: maxLength)
            self.startX = x
            self.startY = y
            self.lastX = CGFloat(x)
            self.lastY = CGFloat(y)
            self.angle = angle
        }
        
        fileprivate func updateAndDraw(
            inContext context: CGContext,
            withColor1 color1: CGColor,
            color2: CGColor
        ) -> Bool {
            
            if currentLength >= finalLength {
                if numberOfPods >= maxNumberOfPods {
                    return false
                } else {
//                    context.fillEllipse(in: <#T##CGRect#>)
                    numberOfPods += 1
                    return true
                }
            } else {
                let growth = Random.f(greater: finalLength * 0.01, smaller: finalLength * 0.05)
                currentLength += growth
                
                let newX = lastX + CGFloat(cosf(angle) * growth)
                let newY = lastY + CGFloat(sinf(angle) * growth)
                
                context.beginPath()
                context.move(to: CGPoint(x: lastX, y: lastY))
                context.addLine(to: CGPoint(x: newX, y: newY))
                context.closePath()
                context.strokePath()
                
                lastX = newX
                lastY = newY
                return true
            }
            
        }
    }
}
