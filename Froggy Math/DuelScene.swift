//
//  DuelScene.swift
//  Froggy Math
//
//  Created by David Chu on 8/27/23.
//

import SpriteKit
import GameplayKit

class DuelScene: SKScene, ButtonDelegate, FrogDelegate, FlyDelegate {
    static let numbersTopMargin = 0.05
    static let waitSecBetweenProblems = 0.5
    
    var solved = [0, 0]
    var difficulty = Difficulty.easy
    
    var player0ButtonsTop: CGFloat!
    var player1ButtonsBottom: CGFloat!
    
    var problemWindows = [ProblemWindow]()
    var problemNum1 = 0
    var problemNum2 = 0
    var inputs = [0, 0]
    var inputButtons = [[Button](), [Button]()]
    var playerButtonDelegates = [PlayerButtonDelegate]()
    
    var frogs = [Frog]()
    var fly: Fly?
    var flyCounters = [FlyCounter]()
    
    var duelOverWindow: DuelOverWindow?
    
    override init() {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
    }
                   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
                   
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        playerButtonDelegates.append(PlayerButtonDelegate(parent: self, playerNum: 0))
        playerButtonDelegates.append(PlayerButtonDelegate(parent: self, playerNum: 1))
        createOtherButtons()
        createNumButtons()
        createFrogs()
        createProblemWindow()
        createFlyCounter()
        resetValues()
    }
   
    func createFrogs() {
        let frog0 = Frog(type: .basic, loadSounds: true, delegate: self)
        frog0.position = CGPoint(x: Util.windowWidth() - Frog.getWidth() / 1.5, y: player0ButtonsTop)
        addChild(frog0)
        frogs.append(frog0)
        
        let frog1 = Frog(type: .basic, loadSounds: true, delegate: self)
        frog1.position = CGPoint(x: Frog.getWidth() / 1.5, y: player1ButtonsBottom)
        frog1.zRotation = .pi
        addChild(frog1)
        frogs.append(frog1)
    }
    
    func createOtherButtons() {
        let enterButton0 = Button(type: .enter, size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: playerButtonDelegates[0])
        enterButton0.position = CGPoint(x: Util.width(percent: 1 - Util.marginPercent - NumberButton.numButtonSizePercent), y: Util.height(percent: BattleScene.numbersBottomMargin) + Util.width(percent: NumberButton.numButtonSizePercent * 1.5 + NumberButton.insetPercent))
        addChild(enterButton0)
        
        let clearButton0 = Button(type: .clear, size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: playerButtonDelegates[0])
        clearButton0.position = CGPoint(x: Util.margin(), y: enterButton0.position.y)
        addChild(clearButton0)
        
        inputButtons[0].append(enterButton0)
        inputButtons[0].append(clearButton0)
        
        let enterButton1 = Button(type: .enter, size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: playerButtonDelegates[1])
        enterButton1.position = CGPoint(x: Util.width(percent: Util.marginPercent + NumberButton.numButtonSizePercent), y: Util.height(percent: 1 - DuelScene.numbersTopMargin) - Util.width(percent: NumberButton.numButtonSizePercent * 1.5 + NumberButton.insetPercent))
        enterButton1.zRotation = .pi
        addChild(enterButton1)
        
        let clearButton1 = Button(type: .clear, size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: playerButtonDelegates[1])
        clearButton1.position = CGPoint(x: Util.width(percent: 1 - Util.marginPercent), y: enterButton1.position.y)
        clearButton1.zRotation = .pi
        addChild(clearButton1)
        
        inputButtons[1].append(enterButton1)
        inputButtons[1].append(clearButton1)
    }
    
    func createNumButtons() {
        var buttons = [[NumberButton](), [NumberButton]()]
        let style = Settings.getNumberStyle()
        for num in NumberTypes.allCases {
            for i in 0...1 {
                let button = NumberButton(num: num, style: style, delegate: playerButtonDelegates[i])
                if i == 1 {
                    button.zRotation = .pi
                }
                addChild(button)
                buttons[i].append(button)
                inputButtons[i].append(button)
            }
        }
        
        // positioning
        let bottomMargin0 = Util.height(percent: BattleScene.numbersBottomMargin)
        let midWidth0 = Util.width(percent: (1.0 - Button.sizePercent) / 2)
        let buttonSize = Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
        
        buttons[0][0].position = CGPoint(x: midWidth0, y: bottomMargin0)
        
        buttons[0][7].position = CGPoint(x: midWidth0 - buttonSize, y: bottomMargin0 + buttonSize)
        buttons[0][8].position = CGPoint(x: midWidth0, y: bottomMargin0 + buttonSize)
        buttons[0][9].position = CGPoint(x: midWidth0 + buttonSize, y: bottomMargin0 + buttonSize)
        
        buttons[0][4].position = CGPoint(x: midWidth0 - buttonSize, y: bottomMargin0 + buttonSize * 2)
        buttons[0][5].position = CGPoint(x: midWidth0, y: bottomMargin0 + buttonSize * 2)
        buttons[0][6].position = CGPoint(x: midWidth0 + buttonSize, y: bottomMargin0 + buttonSize * 2)
        
        buttons[0][1].position = CGPoint(x: midWidth0 - buttonSize, y: bottomMargin0 + buttonSize * 3)
        buttons[0][2].position = CGPoint(x: midWidth0, y: bottomMargin0 + buttonSize * 3)
        buttons[0][3].position = CGPoint(x: midWidth0 + buttonSize, y: bottomMargin0 + buttonSize * 3)
        
        let buttonsTotalHeight = Util.width(percent: NumberButton.numButtonSizePercent * 4 + NumberButton.insetPercent * 3)
        player0ButtonsTop = bottomMargin0 + buttonsTotalHeight
        
        let topMargin1 = Util.height(percent: 1.0 - DuelScene.numbersTopMargin)
        let midWidth1 = Util.width(percent: (1.0 + Button.sizePercent) / 2)
        
        buttons[1][0].position = CGPoint(x: midWidth1, y: topMargin1)
        
        buttons[1][7].position = CGPoint(x: midWidth1 + buttonSize, y: topMargin1 - buttonSize)
        buttons[1][8].position = CGPoint(x: midWidth1, y: topMargin1 - buttonSize)
        buttons[1][9].position = CGPoint(x: midWidth1 - buttonSize, y: topMargin1 - buttonSize)
        
        buttons[1][4].position = CGPoint(x: midWidth1 + buttonSize, y: topMargin1 - buttonSize * 2)
        buttons[1][5].position = CGPoint(x: midWidth1, y: topMargin1 - buttonSize * 2)
        buttons[1][6].position = CGPoint(x: midWidth1 - buttonSize, y: topMargin1 - buttonSize * 2)
        
        buttons[1][1].position = CGPoint(x: midWidth1 + buttonSize, y: topMargin1 - buttonSize * 3)
        buttons[1][2].position = CGPoint(x: midWidth1, y: topMargin1 - buttonSize * 3)
        buttons[1][3].position = CGPoint(x: midWidth1 - buttonSize, y: topMargin1 - buttonSize * 3)
        
        player1ButtonsBottom = topMargin1 - buttonsTotalHeight
    }
    
    func createProblemWindow() {
        let problemWindow0 = ProblemWindow()
        problemWindow0.position = CGPoint(x: Util.windowWidth() / 2, y: player0ButtonsTop + Util.margin() * 2)
        addChild(problemWindow0)
        problemWindows.append(problemWindow0)
        
        let problemWindow1 = ProblemWindow()
        problemWindow1.position = CGPoint(x: Util.windowWidth() / 2, y: player1ButtonsBottom - Util.margin() * 2)
        problemWindow1.zRotation = .pi
        addChild(problemWindow1)
        problemWindows.append(problemWindow1)
    }
    
    func createFlyCounter() {
        let flyCounter0 = FlyCounter(type: .numbered)
        flyCounter0.position = CGPoint(x: Util.margin() * 2, y: player0ButtonsTop)
        addChild(flyCounter0)
        flyCounters.append(flyCounter0)
        
        let flyCounter1 = FlyCounter(type: .numbered)
        flyCounter1.position = CGPoint(x: Util.width(percent: 1.0 - Util.marginPercent * 2), y: player1ButtonsBottom)
        flyCounter1.zRotation = .pi
        addChild(flyCounter1)
        flyCounters.append(flyCounter1)
    }
    
    func newProblem() {
        problemNum1 = Settings.getTimesTable().randomElement()!
        problemNum2 = Int.random(in: 2...9)
        inputs = [0, 0]
        refreshProblemWindow()
        refreshFlyCounter()
        
        fly?.removeFromParent()
        fly = Fly(type: .duel, difficulty: difficulty, delegate: self)
        self.addChild(fly!)
    }
    
    func refreshProblemWindow() {
        problemWindows[0].changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: inputs[0])
        problemWindows[1].changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: inputs[1])
    }
    
    func refreshFlyCounter() {
        flyCounters[0].setCount(solved[0])
        flyCounters[1].setCount(solved[1])
    }
    
    func resetValues() {
        solved = [0, 0]
        newProblem()
        refreshFlyCounter()
    }
    
    func onFrogPressed() {
        print("frog pressed!")
    }
    
    class PlayerButtonDelegate: ButtonDelegate, NumberButtonDelegate {
        let parent: DuelScene!
        let playerNum: Int
        
        init(parent: DuelScene, playerNum: Int) {
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
        inputs[playerNum] = inputs[playerNum] * 10 + num.rawValue
        refreshProblemWindow()
    }
    
    func onButtonPressed(button: ButtonTypes, playerNum: Int) {
        switch(button) {
        case .enter:
            onEnterPressed(playerNum: playerNum)
        case .clear:
            onClearPressed(playerNum: playerNum)
        default:
            print("unhandled button type in BattleScene")
        }
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch(button) {
        case .home:
            scene?.view?.presentScene(GameScene())
        case .replay:
            resetValues()
        default:
            print("unhandled button type in BattleScene")
        }
    }
    
    func onEnterPressed(playerNum: Int) {
        guard inputs[playerNum] != 0 else {
            return
        }
        let answer = problemNum1 * problemNum2
        
        if inputs[playerNum] != answer {
            indicateIncorrect(playerNum: playerNum)
        }
        else {
            frogs[playerNum].tongue(to: fly!.position)
            solved[playerNum] += 1
            
            inputs = [0, 0]
            fly?.removeFromParent()
            problemWindows.forEach({$0.clear()})
            inputButtons.forEach({$0.forEach({$0.setDisabledColor()})})
            DispatchQueue.main.asyncAfter(deadline: .now() + DuelScene.waitSecBetweenProblems) {
                self.inputButtons.forEach({$0.forEach({$0.setDefaultColor()})})
                self.newProblem()
            }
        }
        
        if solved[playerNum] == BattleScene.totalProblems {
            gameOver()
        }
    }
    
    func onClearPressed(playerNum: Int) {
        let onesPlace = inputs[playerNum] % 10
        inputs[playerNum] = (inputs[playerNum] - onesPlace) / 10
        refreshProblemWindow()
    }
    
    // the answer the user inputted was wrong
    func indicateIncorrect(playerNum: Int) {
        let flareButtons = SKAction.run {
            for button in self.inputButtons[playerNum] {
                button.setIncorrectColor()
            }
            self.problemWindows[playerNum].setIncorrectColor()
        }
        let wait = SKAction.wait(forDuration: BattleScene.incorrectTime)
        let unflareButtons = SKAction.run {
            self.inputs[playerNum] = 0
            for button in self.inputButtons[playerNum] {
                button.setDefaultColor()
            }
            self.problemWindows[playerNum].setDefaultColor()
        }
        let sequence = SKAction.sequence([flareButtons, wait, unflareButtons])
        run(sequence)
    }
    
    func gameOver() {
        let winner: Int!
        if solved[0] > solved[1] {
            winner = 0
        }
        else {
            winner = 1
        }
        
        duelOverWindow = DuelOverWindow(winner: winner, buttonTypes: [.home, .replay], delegate: self)
        addChild(duelOverWindow!)
        duelOverWindow?.animate(solved: solved)
        
        Settings.addCoins(solved[0] + solved[1])
    }
    
    func flyReachedBottom() {}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


import Foundation
