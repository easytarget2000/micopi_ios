// Based on
// https://github.com/nicklockwood/VectorMath/blob/master/VectorMath/VectorMath.swift

import Foundation

struct Vector2: Hashable {
    var x: Double
    var y: Double
}

extension Vector2 {
    static let zero = Vector2(0, 0)
    
    var lengthSquared: Double {
        return x * x + y * y
    }
    
    var length: Double {
        return sqrt(lengthSquared)
    }
    
    var inverse: Vector2 {
        return -self
    }
    
    init(_ x: Double, _ y: Double) {
        self.init(x: x, y: y)
    }
    func dot(_ v: Vector2) -> Double {
        return x * v.x + y * v.y
    }
    
    func cross(_ v: Vector2) -> Double {
        return x * v.y - y * v.x
    }
    
    func normalized() -> Vector2 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }
    
    func rotated(by radians: Double) -> Vector2 {
        let cs = cos(radians)
        let sn = sin(radians)
        return Vector2(x * cs - y * sn, x * sn + y * cs)
    }
    
    func rotated(by radians: Double, around pivot: Vector2) -> Vector2 {
        return (self - pivot).rotated(by: radians) + pivot
    }
    
    func angle(with v: Vector2) -> Double {
        if self == v {
            return 0
        }
        
        let t1 = normalized()
        let t2 = v.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1, min(1, t1.dot(t2)))
        
        return atan2(cross, dot)
    }
    
    func dist(to v: Vector2) -> Double {
        return sqrt(pow(v.x - x, 2.0) + pow(v.y - y, 2.0))
    }
    
    static prefix func - (v: Vector2) -> Vector2 {
        return Vector2(-v.x, -v.y)
    }
    
    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x * rhs.x, lhs.y * rhs.y)
    }
    
    static func * (lhs: Vector2, rhs: Double) -> Vector2 {
        return Vector2(lhs.x * rhs, lhs.y * rhs)
    }
    
    static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x / rhs.x, lhs.y / rhs.y)
    }
    
    static func / (lhs: Vector2, rhs: Double) -> Vector2 {
        return Vector2(lhs.x / rhs, lhs.y / rhs)
    }
    
    static func ~= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y
    }
}
