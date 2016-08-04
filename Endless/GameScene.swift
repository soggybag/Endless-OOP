//
//  GameScene.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundWidth: CGFloat = 800
    let backgrounds: [BackgroundSection]
    let player: Player
    let cameraNode: SKCameraNode
    var lastUpdateTime: CFTimeInterval = 0
    var playerSpeed: CGFloat = 80
    var gameState: GKStateMachine!
    var leftTouchDown = false
    
    
    // MARK: - Init
    
    override init(size: CGSize) {
        let backgroundSize = CGSize(width: backgroundWidth, height: size.height)
        backgrounds = [BackgroundSection(size: backgroundSize),
                       BackgroundSection(size: backgroundSize)]
        
        player = Player()
        cameraNode = SKCameraNode()
        
        super.init(size: size)
        
        setupBackgrounds()
        setupPlayer()
        setupCamera()
        setupStateMachine()
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: - Setup 
    
    func setupBackgrounds() {
        for i in 0 ..< backgrounds.count {
            backgrounds[i].position.x = backgroundWidth * CGFloat(i)
            addChild(backgrounds[i])
        }
    }
    
    func setupPlayer() {
        addChild(player)
        player.position.x = size.width / 2
        player.position.y = 120
        player.zPosition = PostitionZ.Player
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position.x = size.width / 2
        cameraNode.position.y = size.height / 2
    }
    
    func setupStateMachine() {
        let playState = PlayState(scene: self)
        let gameOverState = GameOverState(scene: self)
        
        gameState = GKStateMachine(states: [playState, gameOverState])
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    
    
    
    
    
    
    
    // MARK: - Did Move to View
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
    }
    
    
    
    
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(cameraNode)
            
            if location.x < 0 {
                // This touch was on the left side of the screen
                leftTouchDown = true
                
            } else {
                // This touch was on the right side of the screen
                
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        // Check all touches
        for touch in touches {
            let location = touch.locationInNode(cameraNode)
            if location.x < 0 {
                // This touch was on the left side of the screen
                leftTouchDown = false
                
            } else {
                // This touch was on the right side of the screen
                
            }
        }
    }
   
    
    
    
    // MARK: - Update
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var deltaTime: CFTimeInterval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if deltaTime > 1 {
            deltaTime = 1 / 60
            lastUpdateTime = currentTime
        }
        
        player.position.x += playerSpeed * CGFloat(deltaTime)
        
        
        // distanceTravelled = Int(player.position.x / 30)
        
        cameraNode.position.x = player.position.x
        
        scrollSceneNodes()
        
        

        if leftTouchDown {
            // TODO: Use deltaTime here
            player.fly()
        }
    }
    
    func scrollSceneNodes() {
        for node in backgrounds {
            let x = node.position.x - cameraNode.position.x
            if x < -(backgroundWidth + view!.frame.width / 2) {
                node.position.x += backgroundWidth * 2
                // addContentToSceneNode(node)
                node.ground.reconfigure()
                node.generateContent()
            }
        }
    }
    
    
    
    
    
    // MARK: - Physics Contact
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Player | PhysicsCategory.Destructible {
            print("Player Contact Destructible")
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Indestructible {
            print("Player Contact Indestructible")
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Coin {
            print("PLayer Contact Coin")
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Lava {
            print("Player Contact Lava")
        }
    }
}
