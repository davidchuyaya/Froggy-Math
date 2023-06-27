//
//  FroggiesScene.swift
//  Froggy Math
//
//  Created by David Chu on 6/26/23.
//

import SpriteKit
import GameplayKit

class FroggiesScene: SKScene, ButtonDelegate, FrogDelegate {
    static let frogSizePercent = 0.3
    
    override init() {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createButtons()
        populateFroggies()
    }
    
    func createButtons() {
        let homeButton = Button(type: .home, center: false, delegate: self)
        homeButton.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - Util.width(percent: Util.marginPercent + Button.sizePercent))
        addChild(homeButton)
        
        let prevButton = Button(type: .prev, center: false, delegate: self)
        prevButton.position = CGPoint(x: Util.margin(), y: Util.margin())
        addChild(prevButton)
        
        let nextButton = Button(type: .next, center: false, delegate: self)
        nextButton.position = CGPoint(x: Util.width(percent: 1 - Button.sizePercent - Util.marginPercent), y: prevButton.position.y)
        addChild(nextButton)
    }
    
    func populateFroggies() {
        let frogWidth = Util.width(percent: FroggiesScene.frogSizePercent)
        let frogHeight = frogWidth * Frog.heightRatio
        let frogSize = CGSize(width: frogWidth, height: frogHeight)
        let startY = Util.windowHeight() - Util.width(percent: Button.sizePercent + Util.marginPercent) - frogHeight
        
        // todo handle more frogs than can be fit onto one page
        let ownedFrogs = Set(Settings.getFrogs())
        let numRows = (FrogType.allCases.count / 3) + 1
        for row in 0..<numRows {
            let y = startY - Double(row)*frogHeight
            
            let leftX = Util.windowWidth()/2 - frogWidth*1.5
            let leftFrogType = FrogType.allCases[row*3]
            let leftFrog = Frog(type: leftFrogType, size: frogSize, loadSounds: false, delegate: self)
            leftFrog.position = CGPoint(x: leftX, y: y)
            if !ownedFrogs.contains(leftFrogType) {
                leftFrog.setColorSilhouette()
            }
            addChild(leftFrog)
            
            let middleFrogExists = FrogType.allCases.count > row*3+1
            if middleFrogExists {
                let middleX = Util.windowWidth()/2 - frogWidth*0.5
                let middleFrogType = FrogType.allCases[row*3+1]
                let middleFrog = Frog(type: middleFrogType, size: frogSize, loadSounds: false, delegate: self)
                middleFrog.position = CGPoint(x: middleX, y: y)
                if !ownedFrogs.contains(middleFrogType) {
                    middleFrog.setColorSilhouette()
                }
                addChild(middleFrog)
            }
            
            let rightFrogExists = FrogType.allCases.count > row*3+2
            if rightFrogExists {
                let rightX = Util.windowWidth()/2 + frogWidth*0.5
                let rightFrogType = FrogType.allCases[row*3+2]
                let rightFrog = Frog(type: rightFrogType, size: frogSize, loadSounds: false, delegate: self)
                rightFrog.position = CGPoint(x: rightX, y: y)
                if !ownedFrogs.contains(rightFrogType) {
                    rightFrog.setColorSilhouette()
                }
                addChild(rightFrog)
            }
        }
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch (button) {
        case .home:
            scene?.view?.presentScene(GameScene())
        case .prev:
            print("prev")
        case .next:
            print("next")
        default:
            print("Button on froggies screen not supported")
        }
    }
    
    func onFrogPressed() {
        print("froggie pressed!")
    }
}
