import CoreGraphics

struct FoliageNodeCGDrawer {
    
    let context: CGContext
    let color1: CGColor
    let color2: CGColor
    
    func drawNode(_ node: FoliageNode) {
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
                        x: cgImageSize - node.x,
                        y: node.y,
                        width: 1,
                        height: 1
                    )
                )
            }
        } else {
            context.beginPath()
            context.move(to: node.point())
        }
        
        guard let nextNode = node.nextNode else {
            break
        }
        
        if !mirrored {
            context.addLine(to: nextNode.point())
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
    }
}
