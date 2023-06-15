//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene, NumberButtonDelegate, ButtonDelegate, FrogDelegate, FlyDelegate {
    static let leafWidthPercent = 0.7
    static let leafYPercent = 0.7
    static let flyCounterYPercent = 0.2
    static let flyCounterMargin = 0.005
    
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
    
    var frog: Frog!
    var fly: Fly?
    var flyCounters = [Fly]()
    
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
       fatalError("init(coder:) has not been implemented")
    }
                   
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createBg()
        createFrog()
        createOtherButtons()
        createNumButtons()
        createProblemWindow()
        switch mode {
        case .accuracyMode:
            createFlyCounter()
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
        frog.position = CGPoint(x: Util.margin(), y: Util.margin())
        addChild(frog)
    }
    
    func createOtherButtons() {
        let homeButton = Button(type: .home, center: false, delegate: self)
        homeButton.position = CGPoint(x: Util.margin(), y: Util.windowHeight() - Util.width(percent: Util.marginPercent + Button.sizePercent))
        addChild(homeButton)
        
        let enterButton = Button(type: .enter, center: false, delegate: self)
        enterButton.position = CGPoint(x: Util.width(percent: 1 - Util.marginPercent - Button.sizePercent), y: Frog.getHeight() - Util.width(percent: Button.sizePercent))
        addChild(enterButton)
        
        let clearButton = Button(type: .clear, center: false, delegate: self)
        clearButton.position = CGPoint(x: Util.margin(), y: enterButton.position.y)
        addChild(clearButton)
    }
    
    func createNumButtons() {
        for (i, num) in NumberTypes.allCases.enumerated() {
            let button = NumberButton(num: num, delegate: self)
            let leftSpacing = (NumberButton.getSize() + Util.width(percent: NumberButton.insetSpacingPercent)) * Double(i)
            button.position = CGPoint(x: Util.margin() + leftSpacing, y: Util.margin() + Frog.getHeight())
            addChild(button)
        }
    }
    
    func createProblemWindow() {
        problemWindow = ProblemWindow()
        problemWindow.position = CGPoint(x: Util.windowWidth() / 2, y: Util.windowHeight() / 2)
        addChild(problemWindow)
    }
    
    func createFlyCounter() {
        for i in 0..<BattleScene.totalProblems {
            let fly = Fly(type: .still, difficulty: difficulty, delegate: self)
            let topExtraMargin = CGFloat(i) * (Fly.getSize() + Util.height(percent: BattleScene.flyCounterMargin))
            fly.position = CGPoint(x: Util.margin(), y: Util.height(percent: 1 - BattleScene.flyCounterYPercent) - topExtraMargin)
            addChild(fly)
            flyCounters.append(fly)
        }
    }
    
    func newProblem() {
        problemNum1 = Int.random(in: 2...9)
        problemNum2 = Int.random(in: 2...9)
        input = 0
        refreshProblemWindow()
        
        if let prevFly = fly {
            prevFly.removeFromParent()
        }
        fly = Fly(type: flyType, difficulty: difficulty, delegate: self)
        self.addChild(fly!)
    }
    
    func refreshProblemWindow() {
        problemWindow.changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: input)
    }
    
    func resetValues() {
        solved = 0
        failed = 0
        newProblem()
        for fly in flyCounters {
            fly.setColorNeutral()
        }
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
            scene?.view?.presentScene(GameScene(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight())))
        case .back:
            resetValues()
        case .enter:
            onEnterPressed()
        case .clear:
            onClearPressed()
        default:
            print("unhandled button type in BattleScene")
        }
    }
    
    func onEnterPressed() {
        let answer = problemNum1 * problemNum2
        
        switch (mode) {
        case .zenMode:
            fallthrough
        case .speedMode:
            indicateIncorrect()
            if input != answer {
                clear()
            }
            else {
                frog.tongue(to: fly!.position)
                solved += 1
                newProblem()
            }
        case .accuracyMode:
            if input != answer {
                indicateIncorrect()
                // fly away
                failed += 1
                fly!.exit()
                fly = nil // set to nil so the fly "in focus" is the next fly
                flyCounters[solved + failed - 1].setColorFailed()
            }
            else {
                frog.tongue(to: fly!.position)
                solved += 1
                flyCounters[solved + failed - 1].setColorSucceeded()
            }
            
            if solved + failed == BattleScene.totalProblems {
                gameOver()
            }
            else {
                newProblem()
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
        failed += 1
        newProblem()
    }
    
    // the answer the user inputted was wrong
    func indicateIncorrect() {
        
    }
    
    // the user has spent too much time or too many tries on this fly
    func indicateFailed() {
        
    }
    
    func gameOver() {
        let gameOverWindow = AlertWindow(imageFile: FrogStages.file(stage: 0), text: "Game over!", buttonTypes: [.home, .back], delegate: self)
        addChild(gameOverWindow)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
