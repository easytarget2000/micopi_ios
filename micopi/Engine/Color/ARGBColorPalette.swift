import CoreGraphics.CGColor

struct ARGBColorPalette {
    
    let colors: [ARGBColor]
    
    init(colors: [ARGBColor]) {
        self.colors = colors
    }
    
    init(randomColorGenerator: RandomColorGenerator = RandomColorGenerator()) {
        let colors: [ARGBColor] = [
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
            randomColorGenerator.nextARGBColor(),
        ]
        
        self.init(colors: colors)
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
