//
//  Ground.swift
//  EndlessJetpacks
//
//  Created by mitchell hudson on 8/2/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class Ground: SKNode {
    
    
    // MARK: - Properties
    
    let groundNodes = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
    let size: CGSize
    
    
    // MARK: - Init
    
    init(size: CGSize) {
        
        self.size = size
        
        super.init()
        
        setupGround()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Setup
    
    func setupGround() {
        for i in 0 ..< groundNodes.count {
            let node = groundNodes[i]
            addChild(node)
            node.color = UIColor.brown
            let w = size.width / 3
            let h = size.height
            
            node.size = CGSize(width: w, height: h)
            node.position = CGPoint(x: CGFloat(i) * w + w / 2, y: h / 2)
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody!.isDynamic = false
            node.physicsBody!.categoryBitMask = PhysicsCategory.Ground
            node.physicsBody!.collisionBitMask = PhysicsCategory.Player
            node.physicsBody!.contactTestBitMask = PhysicsCategory.None
        }
    }
    
    
    
    
    
    // MARK: - Utility
    
    func reconfigure() {
        let n = arc4random() % 2
        
        switch n {
        case 0:
            groundNodes[1].color = UIColor.red
            groundNodes[1].physicsBody!.categoryBitMask = PhysicsCategory.Lava
            groundNodes[1].physicsBody!.contactTestBitMask = PhysicsCategory.Player
        default:
            reset()
        }
    }
    
    func reset() {
        
        groundNodes[1].color = UIColor.brown
        groundNodes[1].physicsBody!.categoryBitMask = PhysicsCategory.Ground
        groundNodes[1].physicsBody!.contactTestBitMask = PhysicsCategory.None
    }
    
}














