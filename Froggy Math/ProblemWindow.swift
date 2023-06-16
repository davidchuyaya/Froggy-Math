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
        numText.fontName = Util.font
        numText.fontSize = Util.fontSize
        numText.fontColor = .white
        numText.horizontalAlignmentMode = .center
        numText.verticalAlignmentMode = .center
        numText.zPosition = 1
        
        addChild(numText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeNumText(firstNum: Int, secondNum: Int, solution: Int) {
        let solutionText = solution == 0 ? "?" : String(solution)
        numText.text = "\(firstNum) × \(secondNum) = \(solutionText)"
    }
    
    func setIncorrectColor() {
        numText.fontColor = .red
    }
    
    func setDefaultColor() {
        numText.fontColor = .white
    }
}
