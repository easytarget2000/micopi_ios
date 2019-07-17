struct ARGBColor: Equatable {
    
    static let white = ARGBColor(a: 1.0, r: 1.0, g: 1.0, b: 1.0)
    static let black = ARGBColor(a: 1.0, r: 0.0, g: 0.0, b: 0.0)
    static let red = ARGBColor(a: 1.0, r: 1.0, g: 0.0, b: 0.0)
    static let green = ARGBColor(a: 1.0, r: 0.0, g: 1.0, b: 0.0)
    static let blue = ARGBColor(a: 1.0, r: 0.0, g: 0.0, b: 1.0)
    
    let a: Double
    let r: Double
    let g: Double
    let b: Double
    
    init(a: Double, r: Double, g: Double, b: Double) {
        self.a = a
        self.r = r
        self.g = g
        self.b = b
    }
    
    init(hex: Int) {
        let intA = (hex >> 24) & 0xFF
        let intR = (hex >> 16) & 0xFF
        let intG = (hex >> 8) & 0xFF
        let intB = hex & 0xFF
        
        a = ARGBColor.intToRelativeValue(intA)
        r = ARGBColor.intToRelativeValue(intR)
        g = ARGBColor.intToRelativeValue(intG)
        b = ARGBColor.intToRelativeValue(intB)
    }
    
    static func == (lhs: ARGBColor, rhs: ARGBColor) -> Bool {
        return lhs.a == rhs.a
            && lhs.r == rhs.r
            && lhs.g == rhs.g
            && lhs.b == rhs.b
    }
    
    static func intToRelativeValue(_ int: Int) -> Double {
        return Double(int) / Double(0xFF)
    }
    
    func colorWithAlpha(_ alpha: Double) -> ARGBColor {
        return ARGBColor(a: alpha, r: self.r, g: self.g, b: self.b)
    }
}
