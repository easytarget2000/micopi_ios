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
    
    static func == (lhs: ARGBColor, rhs: ARGBColor) -> Bool {
        return lhs.a == rhs.a
            && lhs.r == rhs.r
            && lhs.g == rhs.g
            && lhs.b == rhs.b
    }
}
