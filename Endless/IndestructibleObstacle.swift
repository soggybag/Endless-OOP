//
//  IndestructibleObstacle.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class IndestructibleObstacle: SKSpriteNode {
    
    
    
    // MARK: - Factory Methods
    
    static func getObstacle() -> IndestructibleObstacle {
        let blockSize: CGFloat = 30
        let w = (CGFloat(arc4random() % 4) + 1) * blockSize
        let h = (CGFloat(arc4random() % 4) + 1) * blockSize
        
        return IndestructibleObstacle(size: CGSize(width: w, height: h))
    }
    
    
    
    
    
    
    
    
    // MARK: - Init
    
    init(size: CGSize) {
        
        super.init(texture: nil, color: UIColor.blue, size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Setup 
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Indestructible
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
}
