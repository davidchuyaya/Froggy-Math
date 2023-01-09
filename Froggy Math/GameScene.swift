//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 1/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ButtonDelegate {
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createButtons()
    }
    
    func createButtons() {
        let speedModeButton = Button(type: .speedMode, delegate: self)
        speedModeButton.position = CGPoint(x: 200, y: 200)
        addChild(speedModeButton)
    }
    
    func onButtonPressed(button: ButtonTypes) {
        scene?.view?.presentScene(BattleScene(mode: button))
    }
}
