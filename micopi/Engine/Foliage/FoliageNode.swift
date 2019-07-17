class FoliageNode {
    var positionVector: Vector2
    let maxJitter: Double
    let pushForce: Double
    let radius: Double
    let neighbourGravity: Double
    let preferredNeighbourDistance: Double
    let maxPushDistance: Double
    let pushForceRatio = 0.01
    let radiusRatio = 1.0 / 256.0
    let neighbourGravityRatio = 1.0 / 1.4
    let preferredNeighbourDistanceRatio = 0.1
    var next: FoliageNode?
    var randomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator()
    var jitter: Double {
        get {
            return randomNumberGenerator.d(
                greater: -maxJitter,
                smaller: maxJitter
            )
        }
    }
    
    init(positionVector: Vector2, maxJitter: Double, worldSize: Double) {
        self.positionVector = positionVector
        self.maxJitter = maxJitter
        
        pushForce = worldSize * pushForceRatio
        radius = worldSize * radiusRatio
        neighbourGravity = -radius * neighbourGravityRatio
        preferredNeighbourDistance = worldSize * preferredNeighbourDistanceRatio
        maxPushDistance = worldSize
    }
    
    func update() {
        positionVector = positionVector + Vector2(x: jitter, y: jitter)
        updateAcceleration()
    }
    
    func updateAcceleration() {
        var otherNode = next!
        
        var force = 0.0
        var angle = 0.0
        
        // self.addAccelerationToAttractor();
        var accelerationVector = Vector2.zero
        
        repeat {
            let distance = positionVector.dist(to: otherNode.positionVector)
            
            if (distance > maxPushDistance) {
                guard let nextNode = otherNode.next else {
                    break
                }
                otherNode = nextNode
                continue
            }
            
            let vectorToOtherNode = otherNode.positionVector - positionVector
            angle = positionVector.angle(with: otherNode.positionVector)
                + (angle * 0.05)
            
            force *= 0.05
            
            if (otherNode === next) {
                
                if (distance > self.preferredNeighbourDistance) {
                    // force = mPreferredNeighbourDistanceHalf;
                    force += (distance / self.pushForce);
                } else {
                    force -= self.neighbourGravity;
                }
            } else {
                
                if (distance < self.radius) {
                    force -= self.radius;
                } else {
                    force -= (self.pushForce / distance);
                }
            }
            
            accelerationVector = accelerationVector
                + (vectorToOtherNode.normalized() * force)
            
            guard let nextNode = otherNode.next else {
                break
            }
            otherNode = nextNode
            
        } while (otherNode !== self)
            
        positionVector = positionVector + accelerationVector
    }
    
}
