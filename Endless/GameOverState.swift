//
//  GameOverState.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is PlayState.Type
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        // Animate player death
        print("Entering Game Over State From: \(previousState)")
        scene.player.deathAnimation()
        scene.showGameOver()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        //
    }
}
