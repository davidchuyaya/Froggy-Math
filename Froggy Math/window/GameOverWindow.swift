//
//  GameOverWindow.swift
//  Froggy Math
//
//  Created by David Chu on 6/16/23.
//

import SpriteKit

class GameOverWindow: AlertWindow {
    static let animateTime = 1.0 // higher is slower
    static let rowHeightPercent = 0.05
    static let insetPercent = 0.01
    static let rowMarginPercent = 0.01
    static let statsWidthPercent = 0.5
    
    var progressBar: ProgressBar!
    var coinText: SKLabelNode!
    var accuracyWeekBar: SKSpriteNode!
    var accuracyDayBar: SKSpriteNode!
    var accuracyBar: SKSpriteNode!
    var accuracyText: SKLabelNode!
    var speedWeekBar: SKSpriteNode!
    var speedDayBar: SKSpriteNode!
    var speedBar: SKSpriteNode!
    var speedText: SKLabelNode!
    
    convenience init(reviewNumbers: [(Int, Int)], buttonTypes: [ButtonTypes], delegate: ButtonDelegate, frogDelegate: ProgressFrogDelegate?) {
        var reviewText = ""
        if !reviewNumbers.isEmpty {
            for (num1, num2) in reviewNumbers {
                reviewText += "\n\(num1) × \(num2) = \(num1*num2)"
            }
        }
        let text = "Game over! \(reviewText)"
        
        self.init(image: nil, text: text, buttonTypes: buttonTypes, delegate: delegate)
        
        progressBar = ProgressBar(delegate: frogDelegate)
        progressBar.zPosition = 201
        progressBar.position = CGPoint(x: -Util.windowWidth() / 2, y: 0)
        addChild(progressBar)
        
        let rowHeight = Util.height(percent: GameOverWindow.rowHeightPercent)
        let rowMargin = Util.height(percent: GameOverWindow.rowMarginPercent)
        let inset = Util.width(percent: GameOverWindow.insetPercent)
        
        let coinTextSize = getTextSize(text: "$000")
        let coinRowWidth = coinTextSize.width + inset + rowHeight
        let coinImage = SKSpriteNode(texture: SKTexture(imageNamed: FrogStages.file(stage: 0)), size: CGSize(width: rowHeight, height: rowHeight))
        coinImage.zPosition = 201
        coinImage.anchorPoint = CGPoint(x: 0, y: 0)
        coinImage.position = CGPoint(x: -coinRowWidth / 2, y: progressBar.getBottomY() - rowHeight - rowMargin)
        addChild(coinImage)
        
        coinText = getLabel(text: "$0")
        coinText.position = CGPoint(x: coinImage.position.x + coinImage.size.width + inset, y: coinImage.position.y)
        addChild(coinText)
        
        let statsTextSize = getTextSize(text: "100/m")
        let statsWidth = Util.width(percent: GameOverWindow.statsWidthPercent)
        let statsRowWidth = statsWidth + inset * 2 + statsTextSize.width + rowHeight
        
        let accuracyImage = SKSpriteNode(texture: SKTexture(imageNamed: FrogStages.file(stage: 0)), size: CGSize(width: rowHeight, height: rowHeight))
        accuracyImage.zPosition = 201
        accuracyImage.anchorPoint = CGPoint(x: 0, y: 0)
        accuracyImage.position = CGPoint(x: -statsRowWidth / 2, y: coinImage.position.y - rowHeight - rowMargin)
        addChild(accuracyImage)
        let x = accuracyImage.position.x + rowHeight + inset
        accuracyWeekBar = SKSpriteNode(color: .blue, size: CGSize(width: 0, height: rowHeight))
        accuracyWeekBar.position = CGPoint(x: x, y: accuracyImage.position.y)
        accuracyWeekBar.zPosition = 201
        accuracyWeekBar.anchorPoint = CGPoint(x: 0, y: 0)
        accuracyDayBar = SKSpriteNode(color: .green, size: CGSize(width: 0, height: rowHeight))
        accuracyDayBar.position = CGPoint(x: x, y: accuracyImage.position.y)
        accuracyDayBar.zPosition = 202
        accuracyDayBar.anchorPoint = CGPoint(x: 0, y: 0)
        accuracyBar = SKSpriteNode(color: .yellow, size: CGSize(width: 0, height: rowHeight))
        accuracyBar.position = CGPoint(x: x, y: accuracyImage.position.y)
        accuracyBar.zPosition = 203
        accuracyBar.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(accuracyWeekBar)
        addChild(accuracyDayBar)
        addChild(accuracyBar)
        accuracyText = getLabel(text: "0%")
        accuracyText.position = CGPoint(x: x + statsWidth + inset, y: accuracyImage.position.y)
        addChild(accuracyText)
        
        let speedImage = SKSpriteNode(texture: SKTexture(imageNamed: FrogStages.file(stage: 0)), size: CGSize(width: rowHeight, height: rowHeight))
        speedImage.zPosition = 201
        speedImage.anchorPoint = CGPoint(x: 0, y: 0)
        speedImage.position = CGPoint(x: -statsRowWidth / 2, y: coinImage.position.y - rowHeight * 2 - rowMargin * 2)
        addChild(speedImage)
        
        speedWeekBar = SKSpriteNode(color: .blue, size: CGSize(width: 0, height: rowHeight))
        speedWeekBar.position = CGPoint(x: x, y: speedImage.position.y)
        speedWeekBar.zPosition = 201
        speedWeekBar.anchorPoint = CGPoint(x: 0, y: 0)
        speedDayBar = SKSpriteNode(color: .green, size: CGSize(width: 0, height: rowHeight))
        speedDayBar.position = CGPoint(x: x, y: speedImage.position.y)
        speedDayBar.zPosition = 202
        speedDayBar.anchorPoint = CGPoint(x: 0, y: 0)
        speedBar = SKSpriteNode(color: .yellow, size: CGSize(width: 0, height: rowHeight))
        speedBar.position = CGPoint(x: x, y: speedImage.position.y)
        speedBar.zPosition = 203
        speedBar.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(speedWeekBar)
        addChild(speedDayBar)
        addChild(speedBar)
        speedText = getLabel(text: "0/m")
        speedText.position = CGPoint(x: accuracyText.position.x, y: speedImage.position.y)
        addChild(speedText)
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
    
    func animate(mode: ButtonTypes, solvedFlies: Int, accuracy: Double, speed: Double) {
        let accuracyWeek = max(Settings.getAccuracyWeek(), accuracy)
        let accuracyDay = max(Settings.getAccuracyDay(), accuracy)
        let speedWeek = max(Settings.getSpeedWeek(), speed)
        let speedDay = max(Settings.getSpeedDay(), speed)
        
        let statsWidth = Util.width(percent: GameOverWindow.statsWidthPercent)
        
        accuracyWeekBar.run(SKAction.resize(toWidth: accuracyWeek * statsWidth, duration: GameOverWindow.animateTime))
        speedWeekBar.run(SKAction.resize(toWidth: statsWidth, duration: GameOverWindow.animateTime))
        
        let waitDay = SKAction.wait(forDuration: GameOverWindow.animateTime)
        accuracyDayBar.run(SKAction.sequence([waitDay, SKAction.resize(toWidth: accuracyDay * statsWidth, duration: GameOverWindow.animateTime)]))
        speedDayBar.run(SKAction.sequence([waitDay, SKAction.resize(toWidth: speedDay / speedWeek * statsWidth, duration: GameOverWindow.animateTime)]))
        
        let wait = SKAction.wait(forDuration: GameOverWindow.animateTime * 2)
        accuracyBar.run(SKAction.sequence([wait, SKAction.resize(toWidth: accuracy * statsWidth, duration: GameOverWindow.animateTime)]))
        speedBar.run(SKAction.sequence([wait, SKAction.resize(toWidth: speed / speedWeek * statsWidth, duration: GameOverWindow.animateTime)]))
        let progressBarAction = SKAction.run {
            self.progressBar.animate(mode: mode, solvedFlies: solvedFlies)
        }
        run(SKAction.sequence([wait, progressBarAction]))
        
        if solvedFlies > 0 {
            var currentCoins = 0
            let incCoins = SKAction.run {
                self.coinText.text = "$\(currentCoins)"
                currentCoins += 1
            }
            let coinWait = SKAction.wait(forDuration: GameOverWindow.animateTime / Double(solvedFlies + 1))
            run(SKAction.sequence([wait, SKAction.repeat(SKAction.sequence([incCoins, coinWait]), count: solvedFlies + 1)]))
        }

        if accuracy > 0 {
            let accuracyInt = Int(accuracy * 100)
            var currentAccuracy = 0
            let incAccuracy = SKAction.run {
                self.accuracyText.text = "\(currentAccuracy)%"
                currentAccuracy += 1
            }
            let accuracyWait = SKAction.wait(forDuration: GameOverWindow.animateTime / Double(accuracyInt + 1))
            run(SKAction.sequence([wait, SKAction.repeat(SKAction.sequence([incAccuracy, accuracyWait]), count: accuracyInt + 1)]))
        }
        
        if speed > 0 {
            let speedInt = Int(speed)
            var currentSpeed = 0
            let incSpeed = SKAction.run {
                self.speedText.text = "\(currentSpeed)/m"
                currentSpeed += 1
            }
            let speedWait = SKAction.wait(forDuration: GameOverWindow.animateTime / Double(speedInt + 1))
            run(SKAction.sequence([wait, SKAction.repeat(SKAction.sequence([incSpeed, speedWait]), count: speedInt + 1)]))
        }
    }
}
