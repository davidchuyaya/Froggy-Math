//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene, NumberButtonDelegate, ButtonDelegate, FrogDelegate, FlyDelegate, TimeBarDelegate {
    static let leafWidthPercent = 0.7
    static let leafYPercent = 0.7
    static let flyCounterYPercent = 0.2
    static let flyCounterMargin = 0.005
    static let numbersBottomMargin = 0.05
    static let problemTopMargin = 0.15
    
    static let incorrectTime = 0.2
    static let failedTime = 3.0
    
    static let totalProblems = 10
    var solved = 0
    var failed = 0
    
    var mode: ButtonTypes!
    var flyType: FlyTypes!
    var difficulty = Difficulty.easy
    
    var problemWindow: ProblemWindow!
    var problemNum1 = 0
    var problemNum2 = 0
    var input = 0
    var inputButtons = [Button]()
    
    static let maxReviewNumbers = 3
    var reviewNumbers = [(Int, Int)]()
    
    var numberButtonTopY: CGFloat!
    
    var timeBar: TimeBar?
    
    var frog: Frog!
    var fly: Fly?
    var flyCounters = [Fly]() // used in accuracy mode
    var flyCounter: FlyCounter? // used in speed/zen mode
    
    init(mode: ButtonTypes) {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
        self.mode = mode
        if mode == .speedMode {
            flyType = .spiral
        }
        else {
            flyType = .toLeaf
        }
    }
                   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
                   
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createBg()
        createOtherButtons()
        createNumButtons()
        createFrog()
        createProblemWindow()
        switch mode {
        case .speedMode:
            createTimer()
            fallthrough
        case .zenMode:
            createFlyCounter()
        case .accuracyMode:
            createFlyCounters()
        default:
            break
        }
        resetValues()
    }
    
    func createBg() {
        let leafWidth = Util.width(percent: BattleScene.leafWidthPercent)
        let stemLeaf = SKSpriteNode(texture: SKTexture(imageNamed: "stemLeaf"), size: CGSize(width: leafWidth, height: leafWidth / 1771*1063))
        stemLeaf.anchorPoint = CGPoint(x: 1, y: 0.5)
        stemLeaf.position = CGPoint(x: Util.windowWidth(), y: Util.height(percent: BattleScene.leafYPercent))
        addChild(stemLeaf)
    }
   
    func createFrog() {
        frog = Frog(type: .basic, delegate: self)
        frog.position = CGPoint(x: Util.margin(), y: numberButtonTopY)
        addChild(frog)
    }
    
    func createOtherButtons() {
        let pauseButton = Button(type: .pause, center: false, delegate: self)
        pauseButton.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - Util.width(percent: Util.marginPercent + Button.sizePercent))
        addChild(pauseButton)
        
        let enterButton = Button(type: .enter, size: Util.width(percent: NumberButton.numButtonSizePercent), center: false, delegate: self)
        enterButton.position = CGPoint(x: Util.width(percent: 1 - Util.marginPercent - NumberButton.numButtonSizePercent), y: Util.height(percent: BattleScene.numbersBottomMargin) + Util.width(percent: NumberButton.numButtonSizePercent * 1.5 + NumberButton.insetPercent))
        addChild(enterButton)
        
        let clearButton = Button(type: .clear, size: Util.width(percent: NumberButton.numButtonSizePercent), center: false, delegate: self)
        clearButton.position = CGPoint(x: Util.margin(), y: enterButton.position.y)
        addChild(clearButton)
        
        inputButtons.append(enterButton)
        inputButtons.append(clearButton)
    }
    
    func createNumButtons() {
        var buttons = [NumberButton]()
        for num in NumberTypes.allCases {
            let button = NumberButton(num: num, center: true, delegate: self)
            addChild(button)
            buttons.append(button)
            inputButtons.append(button)
        }
        
        // positioning
        let bottomMargin = Util.height(percent: BattleScene.numbersBottomMargin)
        let midWidth = Util.windowWidth() / 2
        let buttonSize = Util.width(percent: NumberButton.numButtonSizePercent + NumberButton.insetPercent)
        
        buttons[0].position = CGPoint(x: midWidth, y: bottomMargin)
        
        buttons[7].position = CGPoint(x: midWidth - buttonSize, y: bottomMargin + buttonSize)
        buttons[8].position = CGPoint(x: midWidth, y: bottomMargin + buttonSize)
        buttons[9].position = CGPoint(x: midWidth + buttonSize, y: bottomMargin + buttonSize)
        
        buttons[4].position = CGPoint(x: midWidth - buttonSize, y: bottomMargin + buttonSize * 2)
        buttons[5].position = CGPoint(x: midWidth, y: bottomMargin + buttonSize * 2)
        buttons[6].position = CGPoint(x: midWidth + buttonSize, y: bottomMargin + buttonSize * 2)
        
        buttons[1].position = CGPoint(x: midWidth - buttonSize, y: bottomMargin + buttonSize * 3)
        buttons[2].position = CGPoint(x: midWidth, y: bottomMargin + buttonSize * 3)
        buttons[3].position = CGPoint(x: midWidth + buttonSize, y: bottomMargin + buttonSize * 3)
        
        numberButtonTopY = Util.height(percent: BattleScene.numbersBottomMargin) + Util.width(percent: NumberButton.numButtonSizePercent * 4 + NumberButton.insetPercent * 3)
    }
    
    func createProblemWindow() {
        problemWindow = ProblemWindow()
        problemWindow.position = CGPoint(x: Util.windowWidth() / 2, y: Util.height(percent: 1 - BattleScene.problemTopMargin))
        addChild(problemWindow)
    }
    
    func createTimer() {
        let topY = Util.windowHeight() - Util.width(percent: Util.marginPercent * 3 + Button.sizePercent + Fly.stillSizePercent)
        let bottomY = Util.margin() + numberButtonTopY
        timeBar = TimeBar(topY: topY, bottomY: bottomY, delegate: self)
        addChild(timeBar!)
    }
    
    func createFlyCounter() {
        flyCounter = FlyCounter()
        flyCounter!.position = CGPoint(x: Util.width(percent: Util.marginPercent + TimeBar.widthPercent / 2), y: Util.windowHeight() - Util.width(percent: Util.marginPercent * 2 + Button.sizePercent + Fly.stillSizePercent))
        addChild(flyCounter!)
    }
    
    func createFlyCounters() {
        for i in 0..<BattleScene.totalProblems {
            let fly = Fly(type: .still, center: false, difficulty: difficulty, delegate: self)
            let topExtraMargin = CGFloat(i) * (Fly.getSize(type: .still) + Util.height(percent: BattleScene.flyCounterMargin))
            fly.position = CGPoint(x: Util.margin(), y: Util.height(percent: 1 - BattleScene.flyCounterYPercent) - topExtraMargin)
            addChild(fly)
            flyCounters.append(fly)
        }
    }
    
    func newProblem() {
        problemNum1 = Settings.getTimesTable().randomElement()!
        problemNum2 = Int.random(in: 2...9)
        input = 0
        refreshProblemWindow()
        refreshFlyCounter()
        
        if let prevFly = fly {
            prevFly.removeFromParent()
        }
        fly = Fly(type: flyType, center: false, difficulty: difficulty, delegate: self)
        self.addChild(fly!)
    }
    
    func refreshProblemWindow() {
        problemWindow.changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: input)
    }
    
    func refreshFlyCounter() {
        flyCounter?.setCount(solved)
    }
    
    func resetValues() {
        solved = 0
        failed = 0
        newProblem()
        refreshFlyCounter()
        reviewNumbers.removeAll()
        for fly in flyCounters {
            fly.setColorNeutral()
        }
        timeBar?.startTimer()
    }
    
    func onFrogPressed() {
        print("frog pressed!")
    }
    
    func onButtonPressed(num: NumberTypes) {
        input = input * 10 + num.rawValue
        refreshProblemWindow()
    }
    
    func onButtonPressed(button: ButtonTypes) {
        switch(button) {
        case .home:
            scene?.view?.presentScene(GameScene())
        case .pause:
            let pauseWindow = AlertWindow(imageFile: FrogStages.file(stage: 0), text: "Game paused.", buttonTypes: [.home, .resume], delegate: self)
            addChild(pauseWindow)
            pause(true)
        case .resume:
            pause(false)
        case .replay:
            resetValues()
            pause(false)
        case .enter:
            onEnterPressed()
        case .clear:
            onClearPressed()
        default:
            print("unhandled button type in BattleScene")
        }
    }
    
    func onEnterPressed() {
        guard input != 0 else {
            return
        }
        let answer = problemNum1 * problemNum2
        
        switch (mode) {
        case .zenMode:
            fallthrough
        case .speedMode:
            if input != answer {
                indicateIncorrect()
                clear()
            }
            else {
                frog.tongue(to: fly!.position)
                solved += 1
                newProblem()
            }
        case .accuracyMode:
            if input != answer {
                indicateFailed()
                // fly away
                fly!.exit()
                fly = nil // set to nil so the fly "in focus" is the next fly
                flyCounters[solved + failed - 1].setColorFailed()
            }
            else {
                frog.tongue(to: fly!.position)
                solved += 1
                flyCounters[solved + failed - 1].setColorSucceeded()
                newProblem()
            }
            
            if solved + failed == BattleScene.totalProblems {
                gameOver()
            }
        default:
            print("Unsupported mode when enter pressed")
        }
    }
    
    func onClearPressed() {
        clear()
    }
    
    func clear() {
        input = 0
        refreshProblemWindow()
    }
    
    func flyReachedBottom() {
        indicateFailed()
    }
    
    func timeOut() {
        gameOver()
    }
    
    // the answer the user inputted was wrong
    func indicateIncorrect() {
        pause(true)
        let flareButtons = SKAction.run {
            for button in self.inputButtons {
                button.setIncorrectColor()
            }
        }
        let wait = SKAction.wait(forDuration: BattleScene.incorrectTime)
        let unflareButtons = SKAction.run {
            for button in self.inputButtons {
                button.setDefaultColor()
            }
            self.pause(false)
        }
        let sequence = SKAction.sequence([flareButtons, wait, unflareButtons])
        run(sequence)
    }
    
    // the user has spent too much time or too many tries on this fly
    func indicateFailed() {
        failed += 1
        addReviewNumbers()
        pause(true)
        let flareProblem = SKAction.run {
            for button in self.inputButtons {
                button.setIncorrectColor()
            }
            self.problemWindow.changeNumText(firstNum: self.problemNum1, secondNum: self.problemNum2, solution: self.problemNum1 * self.problemNum2)
            self.problemWindow.setIncorrectColor()
        }
        let wait = SKAction.wait(forDuration: BattleScene.failedTime)
        let unflareProblem = SKAction.run {
            self.newProblem()
            for button in self.inputButtons {
                button.setDefaultColor()
            }
            self.problemWindow.setDefaultColor()
            self.pause(false)
        }
        let sequence = SKAction.sequence([flareProblem, wait, unflareProblem])
        run(sequence)
    }
    
    func addReviewNumbers() {
        if reviewNumbers.count < BattleScene.maxReviewNumbers {
            reviewNumbers.append((problemNum1, problemNum2))
        }
    }
    
    func gameOver() {
        var reviewText = ""
        if !reviewNumbers.isEmpty {
            for (num1, num2) in reviewNumbers {
                reviewText += "\n\(num1) × \(num2) = \(num1*num2)"
            }
        }
        
        let gameOverWindow = AlertWindow(imageFile: FrogStages.file(stage: 0), text: "Game over! \(reviewText)", buttonTypes: [.home, .replay], delegate: self)
        addChild(gameOverWindow)
        pause(true)
    }
    
    func pause(_ pause: Bool) {
        if mode == .speedMode {
            timeBar?.isPaused = pause
            fly?.isPaused = pause
        }
        for button in self.inputButtons {
            button.isUserInteractionEnabled = !pause
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
