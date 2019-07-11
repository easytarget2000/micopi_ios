import CoreGraphics

class GradientCGDrawer: NSObject {
    
    var colorSpace = CGColorSpaceCreateDeviceRGB()

    func drawColors(
        _ cgColors: [CGColor],
        inContext context: CGContext,
        size: CGSize,
        angle: CGFloat = 0
    ) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        drawColors(cgColors, inContext: context, rect: rect, angle: angle)
    }

    func drawColors(
        _ cgColors: [CGColor],
        inContext context: CGContext,
        rect: CGRect,
        angle: CGFloat = 0
    ) {
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(
            colorsSpace: self.colorSpace,
            colors: cgColors as CFArray,
            locations: colorLocations
        )!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: rect.height)
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )
    }
}
