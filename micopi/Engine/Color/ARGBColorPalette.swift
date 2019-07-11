import CoreGraphics.CGColor

class ARGBColorPalette: NSObject {
    
    var colors: [ARGBColor]!
        
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
