//
//  StoreScene.swift
//  Froggy Math
//
//  Created by David Chu on 7/16/23.
//

import SpriteKit

class StoreScene: SKScene, ButtonDelegate {
    override init() {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createButtons()
    }
    
    func createButtons() {
        let homeButton = Button(type: .home, center: false, delegate: self)
        homeButton.position = CGPoint(x: Util.margin(), y: Util.height(percent: 1 - GameScene.buttonsTopMargin) - Util.width(percent: Button.sizePercent))
        addChild(homeButton)
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch (button) {
        case .home:
            scene?.view?.presentScene(GameScene())
        default:
            print("Button on store screen not supported")
        }
    }
}
