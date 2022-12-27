//
//  ProblemWindow.swift
//  Froggy Math
//
//  Created by David Chu on 12/23/22.
//

import SpriteKit

class ProblemWindow: SKNode {
    
    var numText: SKLabelNode!
    
    override init() {
        super.init()
        
        numText = SKLabelNode()
        numText.horizontalAlignmentMode = .center
        numText.verticalAlignmentMode = .center
        numText.color = UIColor.white
        numText.zPosition = 1
        
        addChild(numText)
    }
    
    func changeNumText(firstNum: Int, secondNum: Int, solution: Int) {
        let solutionText = solution == 0 ? "?" : String(solution)
        numText.text = "\(firstNum) × \(secondNum) = \(solutionText)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
