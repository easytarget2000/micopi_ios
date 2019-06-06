import CoreGraphics

struct FoliageNodeCGDrawer {
    
    let context: CGContext
    let imageSize: CGFloat
    let maxCircleShapeSize: CGFloat
    let randomGenerator: RandomCGNumberGenerator = RandomCGNumberGenerator()
    let color1: CGColor
    let color2: CGColor
    let shape: Int = 0
    let mirrored: Bool = false
    
    func drawNode(_ node: FoliageNode, nextNode: FoliageNode) {
        if shape == 1 {
            context.setStrokeColor(color2)
            context.strokeEllipse(
                in: CGRect(
                    x: CGFloat(node.x) + CGFloat(1),
                    y: CGFloat(node.x) + CGFloat(1),
                    width: randomGenerator.cgF(smallerThan: maxCircleShapeSize),
                    height: randomGenerator.cgF(smallerThan: maxCircleShapeSize)
                )
            )
        } else {
            context.setFillColor(color2)
            context.fill(
                CGRect(
                    x: CGFloat(node.x) + CGFloat(1),
                    y: CGFloat(node.x) + CGFloat(1),
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
                        x: CGFloat(node.x) + CGFloat(1),
                        y: CGFloat(node.x) + CGFloat(1),
                        width: randomGenerator.cgF(smallerThan: maxCircleShapeSize),
                        height: randomGenerator.cgF(smallerThan: maxCircleShapeSize)
                    )
                )
            } else {
                context.setFillColor(color1)
                context.fill(
                    CGRect(
                        x: imageSize - CGFloat(node.x),
                        y: CGFloat(node.y),
                        width: 1,
                        height: 1
                    )
                )
            }
        } else {
            context.beginPath()
            let point = CGPoint(x: CGFloat(node.x), y: CGFloat(node.y))
            context.move(to: point)
        }
        
//        if !mirrored {
//            context.addLine(to: nextNode.point())
//            context.closePath()
//            context.drawPath(using: CGPathDrawingMode.stroke)
//        }
    }
}
