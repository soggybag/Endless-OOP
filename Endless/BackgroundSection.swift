//
//  BackgroundSection.swift
//  EndlessJetpacks
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class BackgroundSection: SKNode {
    let size: CGSize
    let ground: Ground
    let groundHeight: CGFloat = 40
    let contentNode: SKNode
    
    // MARK: - Init
    
    init(size: CGSize) {
        self.size = size
        self.ground = Ground(size: CGSize(width: size.width, height: groundHeight))
        
        contentNode = SKNode()
        
        super.init()
        
        let hue = CGFloat(arc4random() % 1000) / 1000
        let test = SKSpriteNode(color: UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.3) , size: size)
        addChild(test)
        test.zPosition = PostitionZ.Background
        test.anchorPoint = CGPointZero
        
        setupGround()
        setupContentNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Setup
    
    func setupGround() {
        addChild(ground)
        ground.position.x = 0
        ground.position.y = 0
        ground.zPosition = PostitionZ.Ground
    }
    
    func setupContentNode() {
        addChild(contentNode)
    }
    
    
    
    // MARK: - 
    
    func generateContent() {
        contentNode.removeAllChildren()
        
        let n = arc4random() % 2
        
        switch n {
        case 0:
            let obj = IndestructibleObstacle.getObstacle()
            contentNode.addChild(obj)
            obj.position.x = CGFloat(arc4random() % 600) + 100
            obj.position.y = groundHeight + obj.size.height / 2
            
        case 1:
            let obj = DestructibleObstacle.getObstacle()
            contentNode.addChild(obj)
            obj.position.x = CGFloat(arc4random() % 600) + 100
            let range = UInt32(size.height - obj.size.height - groundHeight)
            let dy = CGFloat(arc4random() % range)
            obj.position.y = groundHeight + obj.size.height / 2 + dy
            
        case 2:
            break
            
        default:
            break
        }
    }
    
    func reset() {
        contentNode.removeAllChildren()
        ground.reset()
    }
    
}
