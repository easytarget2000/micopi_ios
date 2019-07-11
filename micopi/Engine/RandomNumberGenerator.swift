import Foundation

class RandomNumberGenerator: NSObject {
    
    var startPoint: Int {
        didSet {
            srand48(startPoint)
        }
    }
    
    init(startPoint: Int = 0) {
        self.startPoint = startPoint
    }
    
    var int: Int {
        get {
            return i(greater: 0, smaller: Int.max)
        }
    }
    
    func i(smallerThan max: Int) -> Int {
        return Int(drand48() * Double(max))
    }
    
    func i(largerThan min: Int, smallerThan max: Int) -> Int {
        guard min < max else {
            return min
        }
        
        return Int(drand48() * Double(max - min)) + min
    }
    
    func i(greater min: Int, smaller max: Int) -> Int {
        guard min < max else {
            return min
        }
        
        return Int(drand48() * Double(max - min)) + min
    }
    
    func b(withChance chance: Double) -> Bool {
        guard chance > 0 else {
            return false
        }
        
        guard chance < 1 else {
            return true
        }
        
        return Int(drand48() * (1/chance)) % Int(1/chance) == 0
    }
    
    func d(greater min: Double, smaller max: Double) -> Double {
        guard min < max else {
            return min
        }
        
        return (drand48() * Double(max - min)) + min
    }
    
    func f(smallerThan max: Float) -> Float {
        return Float(drand48()) * max
    }
    
    func f(smaller max: Float) -> Float {
        return Float(drand48()) * max
    }
    
    func f(smaller max: Float, greater min: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return (Float(drand48()) * (max - min)) + min
    }
    
    func f(largerThan min: Float, smallerThan max: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return Float(drand48() * Double(max - min)) + min
        
    }
    
    func f(greater min: Float, smaller max: Float) -> Float {
        guard min < max else {
            return min
        }
        
        return Float(drand48() * Double(max - min)) + min
    }
    
}
