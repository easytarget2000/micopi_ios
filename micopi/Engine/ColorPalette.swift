import CoreGraphics.CGColor

struct ColorPalette {
    
    let colorSpace: CGColorSpace
    let palette: [CGColor]
    
    init(colorSpace: CGColorSpace, palette: [CGColor]) {
        self.colorSpace = colorSpace
        self.palette = palette
    }
    
    init() {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorComponents: [[CGFloat]] = [
            [0.0, 0.0, 1.0, 1.0],
            [1.0, 0.0, 0.0, 1.0]
        ]
        
        let palette: [CGColor] = colorComponents.map({
            (components) -> CGColor in
            return CGColor(colorSpace: colorSpace, components: components)!
        })
        self.init(colorSpace: colorSpace, palette: palette)
    }
    
    func color(randomNumber: Int) -> CGColor {
        let randomIndex = abs(randomNumber % palette.count)
        return palette[randomIndex]
    }
}
