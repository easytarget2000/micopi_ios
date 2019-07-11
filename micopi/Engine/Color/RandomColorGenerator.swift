import Foundation.NSObject

class RandomColorGenerator: NSObject {
    
    var randomNumberGenerator: RandomNumberGenerator!
    
    func nextARGBColor(alpha: Double = 1) -> ARGBColor {
        let red = nextColorValue()
        let green = nextColorValue()
        let blue = nextColorValue()
        return ARGBColor(a: alpha, r: red, g: green, b: blue)
    }
    
    func nextColorValue() -> Double {
        return randomNumberGenerator.d(greater: 0.0, smaller: 1.0)
    }
}
