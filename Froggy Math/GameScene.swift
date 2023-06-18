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
        
        createNewEggAlert()
        createButtons()
        createProgressBar()
        refreshStats()
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
    
    func createNewEggAlert() {
        // frog is at final stage and we didn't just evolve
        if Settings.getFrogStage() == 7 && !Settings.didLastEvolveToday() {
            Settings.incrementFrogStage()
            addChild(EvolutionWindow(frogStage: 0))
        }
    }
    
    func refreshStats() {
        // reset stats if they're for the wrong week/day
        if !Settings.isSameWeek() {
            Settings.resetAccuracyWeek()
            Settings.resetSpeedWeek()
        }
        if !Settings.isSameDay() {
            Settings.resetAccuracyDay()
            Settings.resetSpeedDay()
        }
        // If we're in a new week, set today as the start of the week. If we're in a new day, set today as the date
        Settings.refreshDate()
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
