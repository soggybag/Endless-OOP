//
//  PlayState.swift
//  Endless
//
//  Created by mitchell hudson on 8/3/16.
//  Copyright © 2016 mitchell hudson. All rights reserved.
//

import SpriteKit
import GameplayKit

class CountdownState: GKState {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
}
