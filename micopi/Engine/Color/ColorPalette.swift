import CoreGraphics.CGColor

struct CGColorPalette {
    
    let colorSpace: CGColorSpace
    let colors: [CGColor]
    
    init(colorSpace: CGColorSpace, colors: [CGColor]) {
        self.colorSpace = colorSpace
        self.colors = colors
    }
    
    init(argbColors: [ARGBColor]) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors: [CGColor] = argbColors.map({
            (argbColor) -> CGColor in
            let components = CGColorPalette.cgColorComponentsFromARGBColor(
                argbColor
            )
            return CGColor(colorSpace: colorSpace, components: components)!
        })
        self.init(colorSpace: colorSpace, colors: cgColors)
    }
    
    init(randomColorGenerator: RandomColorGenerator = RandomColorGenerator()) {
        let argbColors: [ARGBColor] = [
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
        ]
        
        self.init(argbColors: argbColors)
    }
    
    func color(randomNumber: Int) -> CGColor {
        let randomIndex = abs(randomNumber % colors.count)
        return colors[randomIndex]
    }
    
    static func cgColorComponentsFromARGBColor(
        _ argbColor: ARGBColor
    ) -> [CGFloat] {
        return [
            CGFloat(argbColor.a),
            CGFloat(argbColor.r),
            CGFloat(argbColor.g),
            CGFloat(argbColor.b),
        ]
    }
}
