//
//  DuelOverWindow.swift
//  Froggy Math
//
//  Created by David Chu on 8/27/23.
//

import SpriteKit

class DuelOverWindow: SKNode, ButtonDelegate {
    static let animateTime = 1.0 // higher is slower
    static let rowHeightPercent = 0.05
    static let insetPercent = 0.01
    static let rowMarginPercent = 0.01
    static let statsWidthPercent = 0.5
    
    var coinTexts = [SKLabelNode]()
    var delegate: ButtonDelegate?
    
    init(winner: Int, buttonTypes: [ButtonTypes], delegate: ButtonDelegate) {
        super.init()
        
        self.delegate = delegate
        
        let bg = SKSpriteNode(color: .white, size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
        bg.anchorPoint = CGPoint(x: 0.5, y: 0)
        bg.zPosition = 200
        addChild(bg)
        position = CGPoint(x: Util.windowWidth() / 2, y: 0)
        
        let gameOver0 = SKLabelNode()
        gameOver0.horizontalAlignmentMode = .center
        gameOver0.verticalAlignmentMode = .top
        gameOver0.fontSize = Util.fontSize
        gameOver0.fontName = Util.font
        gameOver0.numberOfLines = 2
        gameOver0.preferredMaxLayoutWidth = Util.width(percent: 1 - Util.marginPercent * 2)
        gameOver0.position = CGPoint(x: 0, y: Util.windowHeight() / 2 - Util.margin())
        gameOver0.fontColor = .black
        gameOver0.zPosition = 201
        bg.addChild(gameOver0)
        
        let gameOver1 = SKLabelNode()
        gameOver1.horizontalAlignmentMode = .center
        gameOver1.verticalAlignmentMode = .top
        gameOver1.fontSize = Util.fontSize
        gameOver1.fontName = Util.font
        gameOver1.numberOfLines = 2
        gameOver1.preferredMaxLayoutWidth = Util.width(percent: 1 - Util.marginPercent * 2)
        gameOver1.position = CGPoint(x: 0, y: Util.windowHeight() / 2 + Util.margin())
        gameOver1.fontColor = .black
        gameOver1.zPosition = 201
        gameOver1.zRotation = .pi
        bg.addChild(gameOver1)
        
        if (winner == 0) {
            gameOver0.text = "Congrats on winning!"
            gameOver1.text = "Better luck next time..."
        }
        else {
            gameOver1.text = "Congrats on winning!"
            gameOver0.text = "Better luck next time..."
        }
        
        let halfNumButtons = Double(buttonTypes.count) / 2.0
        for (i, type) in buttonTypes.enumerated() {
            let button0 = Button(type: type, delegate: self)
            // center button x should be -0.5 * button size, if there is an odd number
            let distanceFromMid = halfNumButtons - Double(i)
            let x0 = (0.5 - distanceFromMid) * (Util.width(percent: Button.sizePercent + Util.marginPercent)) - Util.width(percent: Button.sizePercent * 0.5)
            button0.position = CGPoint(x: x0, y: Util.width(percent: AlertWindow.yMarginPercent))
            button0.zPosition = 201
            bg.addChild(button0)
            
            let button1 = Button(type: type, delegate: self)
            button1.position = CGPoint(x: -x0, y: Util.windowHeight() - Util.width(percent: AlertWindow.yMarginPercent))
            button1.zPosition = 201
            button1.zRotation = .pi
            bg.addChild(button1)
        }
        
        let imageHeight = Util.height(percent: GameOverWindow.rowHeightPercent)
        let rowMargin = Util.height(percent: GameOverWindow.rowMarginPercent)
        let inset = Util.width(percent: GameOverWindow.insetPercent)
        
        let coinTextSize = getTextSize(text: "$000")
        let coinRowWidth = coinTextSize.width + inset + imageHeight
        let coinImage0 = SKSpriteNode(texture: SKTexture(imageNamed: FrogStages.file(stage: 0)), size: CGSize(width: imageHeight, height: imageHeight))
        coinImage0.zPosition = 201
        coinImage0.anchorPoint = CGPoint(x: 0, y: 0)
        coinImage0.position = CGPoint(x: -coinRowWidth / 2, y: gameOver0.position.y - imageHeight * 2 - rowMargin)
        bg.addChild(coinImage0)
        
        let coinImage1 = SKSpriteNode(texture: SKTexture(imageNamed: FrogStages.file(stage: 0)), size: CGSize(width: imageHeight, height: imageHeight))
        coinImage1.zPosition = 201
        coinImage1.anchorPoint = CGPoint(x: 0, y: 0)
        coinImage1.position = CGPoint(x: coinRowWidth / 2, y: gameOver1.position.y + imageHeight * 2 + rowMargin)
        coinImage1.zRotation = .pi
        bg.addChild(coinImage1)
        
        let coinText0 = getLabel(text: "$0")
        coinText0.position = CGPoint(x: coinImage0.position.x + coinImage0.size.width + inset, y: coinImage0.position.y)
        coinTexts.append(coinText0)
        bg.addChild(coinText0)
        
        let coinText1 = getLabel(text: "$0")
        coinText1.position = CGPoint(x: coinImage1.position.x - coinImage1.size.width - inset, y: coinImage1.position.y)
        coinText1.zRotation = .pi
        coinTexts.append(coinText1)
        bg.addChild(coinText1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func animate(solved: [Int]) {
        var currentCoins = [0, 0]
        let incCoins = SKAction.run {
            self.coinTexts[0].text = "$\(currentCoins[0])"
            self.coinTexts[1].text = "$\(currentCoins[1])"
            
            if currentCoins[0] < solved[0] {
                currentCoins[0] += 1
            }
            if currentCoins[1] < solved[1] {
                currentCoins[1] += 1
            }
        }
        let coinWait = SKAction.wait(forDuration: GameOverWindow.animateTime / Double(solved.max()! + 1))
        run(SKAction.sequence([SKAction.repeat(SKAction.sequence([incCoins, coinWait]), count: solved.max()! + 1)]))
    }
    
    func onButtonPressed(button: ButtonTypes) {
        delegate?.onButtonPressed(button: button)
        removeFromParent()
    }
}
