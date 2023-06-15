//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 1/8/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ButtonDelegate {
    static let buttonsBottomMargin = 0.1
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createButtons()
        createEggProgressionWindow()
    }
    
    func createButtons() {
        let accuracyModeButton = Button(type: .accuracyMode, center: true, delegate: self)
        accuracyModeButton.position = CGPoint(x: Util.width(percent: 0.5 - Button.sizePercent - Util.marginPercent), y: Util.height(percent: GameScene.buttonsBottomMargin))
        addChild(accuracyModeButton)
        
        let speedModeButton = Button(type: .speedMode, center: true, delegate: self)
        speedModeButton.position = CGPoint(x: Util.width(percent: 0.5), y: Util.height(percent: GameScene.buttonsBottomMargin))
        addChild(speedModeButton)
        
        let zenModeButton = Button(type: .zenMode, center: true, delegate: self)
        zenModeButton.position = CGPoint(x: Util.width(percent: 0.5 + Button.sizePercent + Util.marginPercent), y: Util.height(percent: GameScene.buttonsBottomMargin))
        addChild(zenModeButton)
    }
    
    func createEggProgressionWindow() {
        if Settings.getFrogStage() == 0 {
            addChild(AlertWindow(imageFile: FrogStages.file(stage: 0), text: "You got a new egg!", buttonTypes: [.ok], delegate: nil))
        }
    }
    
    func onButtonPressed(button: ButtonTypes) {
        scene?.view?.presentScene(BattleScene(mode: button))
    }
}
