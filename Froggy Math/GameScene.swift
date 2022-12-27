//
//  GameScene.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ButtonDelegate, FrogDelegate, FlyDelegate {
    static let totalProblems = 20
    var solved = 0
    var failed = 0
    
    var difficulty = Difficulty.easy
    
    var problemWindow: ProblemWindow!
    var problemNum1 = 0
    var problemNum2 = 0
    var solution = 0
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        createFrog()
        createFlies()
        createNumButtons()
        createProblemWindow()
        newProblem()
        refreshProblemWindow()
    }
    
    func createFrog() {
        let frog = Frog(stage: .egg, delegate: self)
        frog.position = CGPoint(x: Util.margin(), y: Util.margin())
        addChild(frog)
    }
    
    func createFlies() {
        let createFly = SKAction.run {
            let fly = Fly(type: .speed, difficulty: .hard, delegate: self)
            self.addChild(fly)
        }
        let wait = SKAction.wait(forDuration: TimeInterval(Difficulty.hard.timeBetweenProblems()))
        run(SKAction.repeat(SKAction.sequence([createFly, wait]), count: GameScene.totalProblems))
    }
    
    func createNumButtons() {
        for num in NumberTypes.allCases {
            let button = NumberButton(num: num, delegate: self)
            let leftSpacing = (NumberButton.getSize() + Util.width(percent: NumberButton.insetSpacingPercent)) * Double(num.rawValue)
            button.position = CGPoint(x: Util.margin() + leftSpacing, y: Util.margin() * 2 + Frog.getSize())
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
    }
    
    func refreshProblemWindow() {
        problemWindow.changeNumText(firstNum: problemNum1, secondNum: problemNum2, solution: solution)
    }
    
    func onFrogPressed() {
        print("ribbit")
    }
    
    func onButtonPressed(num: NumberTypes) {
        solution = solution * 10 + num.rawValue
        let answer = problemNum1 * problemNum2
        
        if solution > answer {
            solution = 0
        }
        else if solution == answer {
            newProblem()
            solution = 0
        }
        refreshProblemWindow()
    }
    
    func flyReachedBottom() {
        newProblem()
        refreshProblemWindow()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
