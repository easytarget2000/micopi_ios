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
        self.init(
            colorSpace: colorSpace,
            palette: [
                CGColor(colorSpace: colorSpace, components: [1, 1, 1])!,
                CGColor(colorSpace: colorSpace, components: [0.5, 0.5, 0.5])!
            ]
        )
    }
    
    func color(randomNumber: Int) -> CGColor {
        let randomIndex = abs(randomNumber % palette.count)
        return palette[randomIndex]
    }
}
