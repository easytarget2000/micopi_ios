import CoreGraphics

class ARGBColorCGConverter: NSObject {
    
    var argbColorSpace = CGColorSpaceCreateDeviceRGB()
    
    func cgColorFromARGBColor(_ argbColor: ARGBColor) -> CGColor {
        let components = cgColorComponentsFromARGBColor(argbColor)
        return CGColor(colorSpace: argbColorSpace, components: components)!
    }
    
    func cgColorComponentsFromARGBColor(
        _ argbColor: ARGBColor
    ) -> [CGFloat] {
        return [
            CGFloat(argbColor.a),
            CGFloat(argbColor.r),
            CGFloat(argbColor.g),
            CGFloat(argbColor.b),
        ]
    }
    
    func cgColorsFromARGBColors(_ argbColors: [ARGBColor]) -> [CGColor] {
        return argbColors.map({
            (argbColor) -> CGColor in
            return cgColorFromARGBColor(argbColor)
        })
    }
}
