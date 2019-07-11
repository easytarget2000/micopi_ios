struct ARGBColor: Equatable {
    
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
