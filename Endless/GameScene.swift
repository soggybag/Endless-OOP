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
    var gameState: GKStateMachine!
    var leftTouchDown = false
    let gameOver: GameOver
    
    
    // MARK: - Init
    
    override init(size: CGSize) {
        let backgroundSize = CGSize(width: backgroundWidth, height: size.height)
        backgrounds = [BackgroundSection(size: backgroundSize),
                       BackgroundSection(size: backgroundSize)]
        
        player = Player()
        cameraNode = SKCameraNode()
        gameOver = GameOver(size: size)
        
        super.init(size: size)
        
        setupBackgrounds()
        setupPlayer()
        setupCamera()
        setupStateMachine()
        setupPhysics()
        setupGameOver()
        setupCeiling()
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
        resetPlayer()
    }
    
    func resetPlayer() {
        player.position.x = size.width / 2
        player.position.y = 120
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        resetCamera()
    }
    
    func resetCamera() {
        cameraNode.position.x = size.width / 2
        cameraNode.position.y = size.height / 2
    }
    
    func setupStateMachine() {
        let playState = PlayState(scene: self)
        let gameOverState = GameOverState(scene: self)
        let countdownState = CountdownState(scene: self)
        
        gameState = GKStateMachine(states: [playState, gameOverState, countdownState])
        gameState.enterState(PlayState)
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func setupGameOver() {
        cameraNode.addChild(gameOver)
        gameOver.hidden = true
    }
    
    func setupCeiling() {
        let ceilingSize = CGSize(width: size.width, height: 20)
        let ceiling = SKSpriteNode(color: UIColor.darkGrayColor(), size: ceilingSize)
        cameraNode.addChild(ceiling)
        ceiling.position.y = size.height / 2 - ceilingSize.height / 2
        ceiling.zPosition = PostitionZ.Background
        
        ceiling.physicsBody = SKPhysicsBody(rectangleOfSize: ceilingSize)
        ceiling.physicsBody!.dynamic = false
        
    }
    
    
    
    
    
    
    
    // MARK: - Did Move to View
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
    }
    
    
    
    
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        switch gameState.currentState {
        case is PlayState:
            for touch in touches {
                let location = touch.locationInNode(cameraNode)
                
                if location.x < 0 {
                    // This touch was on the left side of the screen
                    leftTouchDown = true
                    player.isFlying = true
                    
                } else {
                    // This touch was on the right side of the screen
                    fireBullet()
                    
                }
            }
            
        case is GameOverState:
            let touch = touches.first!
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == "start over" {
                gameState.enterState(PlayState)
            }
            
        default:
            break
        }
    }
    
    
    // TODO: Refactor into functions to handle touches for states.
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch ends */
        // Check all touches
        switch gameState.currentState {
        case is PlayState:
            for touch in touches {
                let location = touch.locationInNode(cameraNode)
                if location.x < 0 {
                    // This touch was on the left side of the screen
                    leftTouchDown = false
                    player.isFlying = false
                    
                } else {
                    // This touch was on the right side of the screen
                    
                }
            }
            
        case is GameOverState:
            break
            
        default:
            break
            
        }
        
        
    }
    
    
    
    
    // MARK: - Helper Functions 
    
    func showGameOver() {
        gameOver.hidden = false
    }
   
    func restart() {
        // TODO: Reset background
        
        gameOver.hidden = true
        resetBackground()
        resetCamera()
        resetPlayer()
        player.reset()
    }
    
    func resetBackground() {
        for i in 0 ..< backgrounds.count {
            backgrounds[i].position.x = backgroundWidth * CGFloat(i)
            backgrounds[i].reset()
        }
    }
    
    func fireBullet() {
        let bullet = Bullet()
        addChild(bullet)
        bullet.position = player.position
        let move = SKAction.moveByX(size.width / 2, y: 0, duration: 1)
        let remove = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([move, remove]))
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
        
        gameState.updateWithDeltaTime(deltaTime)
        
        // distanceTravelled = Int(player.position.x / 30)
    }
    
    func scrollSceneNodes() {
        cameraNode.position.x = player.position.x
        for background in backgrounds {
            let x = background.position.x - cameraNode.position.x
            if x < -(backgroundWidth + view!.frame.width / 2) {
                background.position.x += backgroundWidth * 2
                
                background.ground.reconfigure()
                background.generateContent()
            }
        }
    }
    
    
    
    
    
    // MARK: - Physics Contact
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Player | PhysicsCategory.Destructible {
            print("Player Contact Destructible")
            gameState.enterState(GameOverState)
            
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Indestructible {
            print("Player Contact Indestructible")
            gameState.enterState(GameOverState)
            
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Coin {
            print("PLayer Contact Coin")
            
        } else if collision == PhysicsCategory.Player | PhysicsCategory.Lava {
            print("Player Contact Lava")
            gameState.enterState(GameOverState)
            
        } else if collision == PhysicsCategory.Bullet | PhysicsCategory.Destructible {
            print("Bullet hit Destructible")
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
    }
}
