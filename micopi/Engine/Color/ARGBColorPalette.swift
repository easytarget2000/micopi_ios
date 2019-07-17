import CoreGraphics.CGColor

class ARGBColorPalette: NSObject {
    
    static let defaultPalette = [
        ARGBColor(hex: 0xFF000000),
        ARGBColor(hex: 0xFF333333),
        ARGBColor(hex: 0xFF101010),
        ARGBColor(hex: 0xFF292929),
        ARGBColor(hex: 0xFF404040),
        ARGBColor(hex: 0xFFE8DDCB),
        ARGBColor(hex: 0xFFCDB380),
        ARGBColor(hex: 0xFF036564),
        ARGBColor(hex: 0xFF033649),
        ARGBColor(hex: 0xFF031634),
        ARGBColor(hex: 0xFF351330),
        ARGBColor(hex: 0xFF424254),
        ARGBColor(hex: 0xFF64908A),
        ARGBColor(hex: 0xFFE8CAA4),
        ARGBColor(hex: 0xFFCC2A41),
    ]
    var colors = ARGBColorPalette.defaultPalette
    
    override init() {}
        
    init(colors: [ARGBColor]) {
        self.colors = colors
    }
    
    func setColorsRandomly(randomColorGenerator: RandomColorGenerator) {
        colors = [
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
        ]
    }
    
    func color(
        randomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator()
    ) -> ARGBColor {
        return color(randomNumber: randomNumberGenerator.int)
    }
    
    func color(randomNumber: Int) -> ARGBColor {
        let randomIndex = abs(randomNumber % colors.count)
        return colors[randomIndex]
    }
    
}
