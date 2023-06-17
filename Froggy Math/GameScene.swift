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
    
    override init() {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createButtons()
        createProgressBar()
        createEggProgressionAlert()
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
        
        let settingsButton = Button(type: .settings, center: false, delegate: self)
        settingsButton.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - Util.width(percent: Util.marginPercent + Button.sizePercent))
        addChild(settingsButton)
    }
    
    func createProgressBar() {
        let progressBar = ProgressBar()
        addChild(progressBar)
    }
    
    func createEggProgressionAlert() {
        if Settings.getFrogStage() == 0 {
            addChild(AlertWindow(imageFile: FrogStages.file(stage: 0), text: "You got a new egg!", buttonTypes: [.ok], delegate: nil))
        }
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch (button) {
        case .accuracyMode, .speedMode, .zenMode:
            scene?.view?.presentScene(BattleScene(mode: button))
        case .settings:
            scene?.view?.presentScene(SettingsScene())
        default:
            print("Button on main screen not supported")
        }
    }
}
