//
//  Player.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    
    
    
    
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
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Lava
        physicsBody!.contactTestBitMask = PhysicsCategory.Destructible | PhysicsCategory.Indestructible | PhysicsCategory.Coin | PhysicsCategory.Lava
    }
    
}
