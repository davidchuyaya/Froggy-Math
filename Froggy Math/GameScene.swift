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
        createEggProgressionWindow()
    }
    
    func createButtons() {
        let speedModeButton = Button(type: .speedMode, center: true, delegate: self)
        speedModeButton.position = CGPoint(x: 200, y: 200)
        addChild(speedModeButton)
        
        let accuracyModeButton = Button(type: .accuracyMode, center: true, delegate: self)
        accuracyModeButton.position = CGPoint(x: 150, y: 200)
        addChild(accuracyModeButton)
        
        let zenModeButton = Button(type: .zenMode, center: true, delegate: self)
        zenModeButton.position = CGPoint(x: 100, y: 200)
        addChild(zenModeButton)
    }
    
    func createEggProgressionWindow() {
        addChild(AlertWindow(imageFile: "hi", text: "you got an egg!"))
        print("Created!")
    }
    
    func onButtonPressed(button: ButtonTypes) {
        scene?.view?.presentScene(BattleScene(mode: button))
    }
}
