//
//  Bullet.swift
//  Endless
//
//  Created by mitchell hudson on 8/4/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
    
    
    
    
    
    // MARK: - Init
    
    init() {
        let bulletSize = CGSize(width: 20, height: 10)
        
        super.init(texture: nil, color: UIColor.cyan, size: bulletSize)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Bullet
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Destructible
    }
    
}
