import CoreGraphics.CGColor

class ARGBColorPalette: NSObject {
    
    var colors: [ARGBColor]!
    
    override init() {}
        
    init(colors: [ARGBColor]) {
        self.colors = colors
    }
    
    func setColorsRandomly(randomColorGenerator: RandomColorGenerator) {
        colors = [
//            ARGBColor.red,
//            ARGBColor.blue
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
//        return ARGBColor.red
        return color(randomNumber: randomNumberGenerator.int)
    }
    
    func color(randomNumber: Int) -> ARGBColor {
        let randomIndex = abs(randomNumber % colors.count)
        return colors[randomIndex]
    }
    
}
