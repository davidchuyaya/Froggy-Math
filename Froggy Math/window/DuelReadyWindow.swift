//
//  DuelReadyWindow.swift
//  Froggy Math
//
//  Created by David Chu on 9/4/23.
//

import SpriteKit

class DuelReadyWindow: SKNode {
    static let maxHandicap = 2
    static let readyAnimateSpeed = 1.0 // lower is faster
    static let rowMarginPercent = 0.03
    static let buttonMarginPercent = 0.04
    
    var delegate: ButtonDelegate?
    var availableFrogs: [FrogType]!
    
    var bg: SKSpriteNode!
    var frog = [Int: Frog]()
    var frogIndex = [Int: Int]()
    var handicap = [Int: Int]()
    var handicapButtons = [Int: [Int: NumberButton]]()
    var oks = [Int: Bool]()
    
    init(delegate: ButtonDelegate) {
        super.init()
        
        self.delegate = delegate
        availableFrogs = Settings.getFrogs()
        
        bg = SKSpriteNode(color: .white, size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.zPosition = 200
        addChild(bg)
        
        let player0Delegate = PlayerButtonDelegate(parent: self, playerNum: 0)
        let player1Delegate = PlayerButtonDelegate(parent: self, playerNum: 1)
        
        let frog0Type = Settings.getDuelist0Frog()
        frogIndex[0] = availableFrogs.firstIndex(of: frog0Type)!
        frog[0] = Frog(type: frog0Type, loadSounds: false)
        frog[0]!.position = CGPoint(x: Util.width(percent: 0.5) - Frog.getWidth() / 2, y: Util.height(percent: 0.5) - Frog.getHeight())
        frog[0]!.zPosition = 201
        bg.addChild(frog[0]!)
        let frog0Left = Button(type: .prev, delegate: player0Delegate)
        frog0Left.position = CGPoint(x: Util.margin(), y: frog[0]!.position.y)
        frog0Left.zPosition = 201
        bg.addChild(frog0Left)
        let frog0Right = Button(type: .next, delegate: player0Delegate)
        frog0Right.position = CGPoint(x: Util.width(percent: 1.0 - Util.marginPercent - Button.sizePercent), y: frog[0]!.position.y)
        frog0Right.zPosition = 201
        bg.addChild(frog0Right)
        
        let frog1Type = Settings.getDuelist1Frog()
        frogIndex[1] = availableFrogs.firstIndex(of: frog1Type)!
        frog[1] = Frog(type: frog1Type, loadSounds: false)
        frog[1]!.position = CGPoint(x: Util.width(percent: 0.5) + Frog.getWidth() / 2, y: Util.height(percent: 0.5) + Frog.getHeight())
        frog[1]!.zPosition = 201
        frog[1]!.zRotation = .pi
        bg.addChild(frog[1]!)
        let frog1Left = Button(type: .prev, delegate: player1Delegate)
        frog1Left.position = CGPoint(x: Util.width(percent: 1.0 - Util.marginPercent), y: frog[1]!.position.y)
        frog1Left.zPosition = 201
        frog1Left.zRotation = .pi
        bg.addChild(frog1Left)
        let frog1Right = Button(type: .next, delegate: player1Delegate)
        frog1Right.position = CGPoint(x: Util.width(percent: Util.marginPercent + Button.sizePercent), y: frog[1]!.position.y)
        frog1Right.zPosition = 201
        frog1Right.zRotation = .pi
        bg.addChild(frog1Right)
        
        let start0 = Button(type: .ok, delegate: player0Delegate)
        start0.position = CGPoint(x: Util.width(percent: 0.5 - Button.sizePercent / 2), y: Util.width(percent: AlertWindow.yMarginPercent))
        start0.zPosition = 201
        bg.addChild(start0)
        
        let start1 = Button(type: .ok, delegate: player1Delegate)
        start1.position = CGPoint(x: Util.width(percent: 0.5 + Button.sizePercent / 2), y: Util.windowHeight() - Util.width(percent: AlertWindow.yMarginPercent))
        start1.zPosition = 201
        start1.zRotation = .pi
        bg.addChild(start1)
    
        let inset = Util.width(percent: DuelReadyWindow.buttonMarginPercent)
        let rowMargin = Util.height(percent: DuelReadyWindow.rowMarginPercent)
        let buttonSize = Util.width(percent: NumberButton.numButtonSizePercent)
        
        let handicap = "Handicap"
        let handicapSize = getTextSize(text: handicap)
        let rowWidth = Util.width(percent: Double(DuelReadyWindow.maxHandicap + 1) * (NumberButton.numButtonSizePercent + Util.marginPercent)) + handicapSize.width
        let rowBottomY = frog[0]!.position.y - rowMargin - buttonSize
        
        let handicapText0 = getLabel(text: handicap)
        handicapText0.position = CGPoint(x: (Util.windowWidth() - rowWidth) / 2, y: rowBottomY + buttonSize / 2 - handicapSize.height / 2)
        handicapText0.zPosition = 201
        bg.addChild(handicapText0)
        handicapButtons[0] = [:]
        
        let handicapText1 = getLabel(text: handicap)
        handicapText1.position = CGPoint(x: (Util.windowWidth() + rowWidth) / 2, y: Util.windowHeight() - handicapText0.position.y)
        handicapText1.zPosition = 201
        handicapText1.zRotation = .pi
        bg.addChild(handicapText1)
        handicapButtons[1] = [:]
        
        for i in 0...DuelReadyWindow.maxHandicap {
            let numType = NumberTypes(rawValue: i)!
            
            let numButton0 = NumberButton(num: numType, style: Settings.getNumberStyle(), delegate: player0Delegate)
            numButton0.position = CGPoint(x: handicapText0.position.x + handicapSize.width + Double(i) * (inset + buttonSize) + inset, y: rowBottomY)
            numButton0.zPosition = 201
            bg.addChild(numButton0)
            handicapButtons[0]![i] = numButton0
            
            let numButton1 = NumberButton(num: numType, style: Settings.getNumberStyle(), delegate: player1Delegate)
            numButton1.position = CGPoint(x: Util.windowWidth() - numButton0.position.x, y: Util.windowHeight() - rowBottomY)
            numButton1.zPosition = 201
            numButton1.zRotation = .pi
            bg.addChild(numButton1)
            handicapButtons[1]![i] = numButton1
        }
        
        oks[0] = false
        oks[1] = false
        
        onButtonPressed(num: NumberTypes(rawValue: Settings.getDuelist0Handicap())!, playerNum: 0)
        onButtonPressed(num: NumberTypes(rawValue: Settings.getDuelist1Handicap())!, playerNum: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class PlayerButtonDelegate: ButtonDelegate, NumberButtonDelegate {
        let parent: DuelReadyWindow!
        let playerNum: Int
        
        init(parent: DuelReadyWindow, playerNum: Int) {
            self.parent = parent
            self.playerNum = playerNum
        }
        
        func onButtonPressed(num: NumberTypes) {
            parent.onButtonPressed(num: num, playerNum: playerNum)
        }
        
        func onButtonPressed(button: ButtonTypes) {
            parent.onButtonPressed(button: button, playerNum: playerNum)
        }
    }
    
    func onButtonPressed(num: NumberTypes, playerNum: Int) {
        guard !oks[playerNum]! else {
            return
        }
        
        handicapButtons[playerNum]!.forEach({$0.value.setInactiveColor()})
        handicapButtons[playerNum]![num.rawValue]!.setDefaultColor()
        handicap[playerNum] = num.rawValue
    }
    
    func onButtonPressed(button: ButtonTypes, playerNum: Int) {
        guard !oks[playerNum]! else {
            return
        }
        
        switch (button) {
        case .prev:
            frogIndex[playerNum]! -= 1
            if frogIndex[playerNum]! < 0 {
                frogIndex[playerNum]! = availableFrogs.count - 1
            }
            frog[playerNum]!.setNewType(availableFrogs[frogIndex[playerNum]!])
        case .next:
            frogIndex[playerNum]! += 1
            if frogIndex[playerNum]! == availableFrogs.count {
                frogIndex[playerNum]! = 0
            }
            frog[playerNum]!.setNewType(availableFrogs[frogIndex[playerNum]!])
        case .ok:
            oks[playerNum] = true
            animateReady(playerNum: playerNum)
            if oks[0]! && oks[1]! {
                delegate?.onButtonPressed(button: button)
                Settings.setDuelist0Frog(availableFrogs[frogIndex[0]!])
                Settings.setDuelist1Frog(availableFrogs[frogIndex[1]!])
                Settings.setDuelist0Handicap(handicap[0]!)
                Settings.setDuelist1Handicap(handicap[1]!)
                animateStart()
            }
        default:
            print("Unsupported button type \(button.file()) in DuelReadyWindow")
        }
    }
    
    func getTextSize(text: String) -> CGSize {
        let font = UIFont(name: Util.font, size: Util.fontSize)!
        return (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func getLabel(text: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .bottom
        label.fontSize = Util.fontSize
        label.fontName = Util.font
        label.fontColor = .black
        label.zPosition = 201
        return label
    }
    
    func animateReady(playerNum: Int) {
        let log = Log(type: availableFrogs[frogIndex[playerNum]!], animate: false)
        let grayOut = SKSpriteNode(color: .black, size: CGSize(width: Util.windowWidth(), height: Util.windowHeight() / 2))
        
        let startX: Double
        let startY: Double
        let grayOutY: Double
        let grayOutFinalX: Double
        if playerNum == 0 {
            startX = Util.windowWidth()
            startY = Util.windowHeight() / 4
            grayOutY = 0
            grayOutFinalX = 0
        }
        else {
            startX = 0
            startY = Util.windowHeight() * 0.75
            grayOutY = Util.windowHeight()
            grayOutFinalX = Util.windowWidth()
            grayOut.zRotation = .pi
            log.zRotation = .pi
        }
        log.position = CGPoint(x: startX, y: startY)
        log.zPosition = 203
        bg.addChild(log)
        
        grayOut.position = CGPoint(x: startX, y: grayOutY)
        grayOut.anchorPoint = CGPoint(x: 0, y: 0)
        grayOut.zPosition = 202
        bg.addChild(grayOut)
        
        grayOut.run(SKAction.moveTo(x: grayOutFinalX, duration: DuelReadyWindow.readyAnimateSpeed))
        log.run(SKAction.moveTo(x: Util.windowWidth() / 2, duration: DuelReadyWindow.readyAnimateSpeed))
    }
    
    func animateStart() {
        let y = (Util.windowHeight() - Util.width(percent: NumberButton.numButtonSizePercent)) * 0.5
        let three = NumberButton(num: .three, style: Settings.getNumberStyle())
        three.position = CGPoint(x: Util.width(percent: 0.5 + 0.5 * NumberButton.numButtonSizePercent + DuelReadyWindow.buttonMarginPercent), y: y)
        three.zPosition = 204
        let two = NumberButton(num: .two, style: Settings.getNumberStyle())
        two.position = CGPoint(x: Util.width(percent: 0.5 - 0.5 * NumberButton.numButtonSizePercent), y: y)
        two.zPosition = 204
        let one = NumberButton(num: .one, style: Settings.getNumberStyle())
        one.position = CGPoint(x: Util.width(percent: 0.5 - 1.5 * NumberButton.numButtonSizePercent - DuelReadyWindow.buttonMarginPercent), y: y)
        one.zPosition = 204
        bg.addChild(three)
        bg.addChild(two)
        bg.addChild(one)
        
        let scaleDown = SKAction.scale(to: 0, duration: 1.0)
        three.run(scaleDown, completion: {
            two.run(scaleDown, completion: {
                one.run(scaleDown, completion: {
                    self.removeFromParent()
                })
            })
        })
    }
}
