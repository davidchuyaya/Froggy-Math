//
//  SettingsScene.swift
//  Froggy Math
//
//  Created by David Chu on 6/15/23.
//

import SpriteKit
import GameplayKit

class SettingsScene: SKScene, ButtonDelegate, NumberButtonDelegate, LanguageButtonDelegate {
    
    var sectionLabelHeight: CGFloat!
    var numberButtons = [NumberButton]() // note that index 0 = button 2 (since 0 and 1 are not times tables)
    var languageButtons = [NumberStyles: NumberButton]()

    override init() {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        let font = UIFont(name: Util.font, size: Util.fontSize)
        sectionLabelHeight = font!.lineHeight
        
        createButtons()
        createTimesTableLabel()
        createTimesTableNumbers(language: Settings.getLanguage())
        createLanguageSection()
    }
    
    func createButtons() {
        let homeButton = Button(type: .home, delegate: self)
        homeButton.position = CGPoint(x: Util.margin(), y: Util.height(percent: 1 - GameScene.buttonsTopMargin) - Util.width(percent: Button.sizePercent))
        addChild(homeButton)
    }
    
    func createTimesTableLabel() {
        let topMargin = Util.height(percent: GameScene.buttonsTopMargin) + Util.width(percent: Util.marginPercent + Button.sizePercent)
        
        let timesTableLabel = SKLabelNode(text: "Times tables")
        timesTableLabel.fontName = Util.font
        timesTableLabel.fontSize = Util.fontSize
        timesTableLabel.fontColor = .white
        timesTableLabel.horizontalAlignmentMode = .left
        timesTableLabel.verticalAlignmentMode = .top
        timesTableLabel.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - topMargin)
        addChild(timesTableLabel)
    }
    
    func createTimesTableNumbers(language: NumberStyles) {
        let topMargin = Util.height(percent: GameScene.buttonsTopMargin) + Util.width(percent: Util.marginPercent + Button.sizePercent)
        let timesTable = Settings.getTimesTable()
        
        outerLoop: for num in NumberTypes.allCases {
            var x = Util.margin()
            var y = Util.windowHeight() - topMargin - sectionLabelHeight - Util.margin() - Util.width(percent: NumberButton.numButtonSizePercent)
            
            switch (num) {
            case .zero, .one:
                continue outerLoop
            case .two, .three, .four, .five:
                x += CGFloat(num.rawValue - 2) * Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
            case .six, .seven, .eight, .nine:
                x += CGFloat(num.rawValue - 6) * Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
                y -= Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
            }
            
            let button = NumberButton(num: num, style: language, numDelegate: self)
            button.position = CGPoint(x: x, y: y)
            if !timesTable.contains(num.rawValue) {
                button.setInactiveColor()
            }
        
            addChild(button)
            numberButtons.append(button)
        }
    }
    
    func createLanguageSection() {
        let timesTableTopMargin = Util.height(percent: GameScene.buttonsTopMargin) + Util.width(percent: Util.marginPercent + Button.sizePercent)
        let languageTableTopMargin = timesTableTopMargin + sectionLabelHeight + Util.margin() * 2 + Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent) * 2
        
        let languageTableLabel = SKLabelNode(text: "Language")
        languageTableLabel.fontName = Util.font
        languageTableLabel.fontSize = Util.fontSize
        languageTableLabel.fontColor = .white
        languageTableLabel.horizontalAlignmentMode = .left
        languageTableLabel.verticalAlignmentMode = .top
        languageTableLabel.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - languageTableTopMargin)
        addChild(languageTableLabel)
        
        let currentLanguage = Settings.getLanguage()
        
        for language in NumberStyles.allCases {
            var x = Util.margin()
            let y = Util.windowHeight() - languageTableTopMargin - sectionLabelHeight - Util.margin() - Util.width(percent: NumberButton.numButtonSizePercent)
            
            switch (language) {
            case .arabic:
                break
            case .chinese:
                x += Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
            }
            
            let button = NumberButton(num: .six, style: language, languageDelegate: self)
            button.position = CGPoint(x: x, y: y)
            if language != currentLanguage {
                button.setInactiveColor()
            }
            
            addChild(button)
            languageButtons[language] = button
        }
    }
    
    func onButtonPressed(num: NumberTypes) {
        var timesTable = Settings.getTimesTable()
        let disabling = timesTable.contains(num.rawValue)
        if disabling {
            let newTimesTable = timesTable.filter({$0 != num.rawValue})
            guard !newTimesTable.isEmpty else {
                return // not allowed to have fewer than 1 number in times table
            }
            Settings.setTimesTable(newTimesTable)
            numberButtons[num.rawValue - 2].setInactiveColor()
        }
        else {
            timesTable.append(num.rawValue)
            Settings.setTimesTable(timesTable)
            numberButtons[num.rawValue - 2].setDefaultColor()
        }
    }
    
    func onButtonPressed(language: NumberStyles) {
        let currentLanguage = Settings.getLanguage()
        guard language != currentLanguage else {
            return
        }
        
        for (buttonLanguage, button) in languageButtons {
            if buttonLanguage != language {
                button.setInactiveColor()
            }
            else {
                button.setDefaultColor()
            }
        }
        
        // Recreate the number buttons
        numberButtons.forEach({$0.removeFromParent()})
        numberButtons.removeAll()
        createTimesTableNumbers(language: language)
        
        Settings.setLanguage(language: language)
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch (button) {
        case .home:
            scene?.view?.presentScene(GameScene())
        default:
            print("Button on settings screen not supported")
        }
    }
}
