//
//  Player.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var playerSpeed: CGFloat = 80
    var upVector = CGVector(dx: 0, dy: 220)
    var isFlying: Bool = false
    
    
    
    
    
    // MARK: - Init
    
    init() {
        
        let playerSize = CGSize(width: 40, height: 65)
        
        super.init(texture: nil, color: UIColor.blackColor(), size: playerSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Setup
    
    func setup() {
        zPosition = PostitionZ.Player
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody!.allowsRotation = false
        physicsBody!.angularDamping = 0.2
        
        reset()
    }
    
    func reset() {
        isFlying = false
        zRotation = 0
        physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        physicsBody!.angularVelocity = 0
        physicsBody!.allowsRotation = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Lava
        physicsBody!.contactTestBitMask = PhysicsCategory.Destructible | PhysicsCategory.Indestructible | PhysicsCategory.Coin | PhysicsCategory.Lava
    }
    
    
    
    
    // MARK: - Utility 
    
    func move(deltaTime: CFTimeInterval) {
        position.x += playerSpeed * CGFloat(deltaTime)
        if isFlying {
            physicsBody!.applyForce(upVector)
        }
    }
    
    func deathAnimation() {
        physicsBody!.allowsRotation = true
        
        physicsBody!.categoryBitMask = PhysicsCategory.None
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.None
        
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: 35))
        physicsBody!.applyAngularImpulse(20)
    }
    
}
