//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene, NumberButtonDelegate, FrogDelegate, FlyDelegate {
    static let totalProblems = 20
    var solved = 0
    var failed = 0
    
    var mode: ButtonTypes!
    var difficulty = Difficulty.easy
    
    var problemWindow: ProblemWindow!
    var problemNum1 = 0
    var problemNum2 = 0
    var input = 0
    
    var frog: Frog!
    var fly: Fly?
    
    init(mode: ButtonTypes) {
        super.init(size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
        self.mode = mode
    }
                   
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
                   
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createFrog()
        createNumButtons()
        createProblemWindow()
        newProblem()
    }
   
    func createFrog() {
        frog = Frog(type: .basic, delegate: self)
        frog.position = CGPoint(x: Util.margin(), y: Util.margin())
        addChild(frog)
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
    
    func newProblem() {
        problemNum1 = Int.random(in: 2...9)
        problemNum2 = Int.random(in: 2...9)
        input = 0
        refreshProblemWindow()
        
        if let prevFly = fly {
            let remove = SKAction.run {
                prevFly.removeFromParent()
            }
            run(SKAction.sequence([SKAction.wait(forDuration: Frog.tongueSpeed * 3), remove]))
        }
        fly = Fly(type: mode, difficulty: difficulty, delegate: self)
        self.addChild(fly!)
    }
    
    func refreshProblemWindow() {
        problemWindow.changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: input)
    }
    
    func onFrogPressed() {
        input = 0
        refreshProblemWindow()
    }
    
    func onButtonPressed(num: NumberTypes) {
        input = input * 10 + num.rawValue
        let answer = problemNum1 * problemNum2
        refreshProblemWindow()
        
        if input > answer {
            input = 0
            refreshProblemWindow()
        }
        else if input == answer {
            frog.tongue(to: fly!.position)
            solved += 1
            newProblem()
        }
    }
    
    func flyReachedBottom() {
        failed += 1
        newProblem()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
