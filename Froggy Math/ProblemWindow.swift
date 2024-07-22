//
//  ProblemWindow.swift
//  Froggy Math
//
//  Created by David Chu on 12/23/22.
//

import SpriteKit

class ProblemWindow: SKNode {
    var numText: SKLabelNode!
    var language: NumberStyles!
    
    override init() {
        super.init()
        
        numText = SKLabelNode()
        numText.fontName = Util.font
        numText.fontSize = Util.fontSize
        numText.fontColor = .white
        numText.horizontalAlignmentMode = .center
        numText.verticalAlignmentMode = .center
        numText.zPosition = 1
        
        language = Settings.getLanguage()
        
        addChild(numText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeNumText(firstNum: Int, secondNum: Int, solution: Int) {
        switch (language) {
        case .arabic:
            let solutionText = solution == 0 ? "?" : String(solution)
            numText.text = "\(firstNum) × \(secondNum) = \(solutionText)"
        case .chinese:
            let solutionText = solution == 0 ? "?" : numToChinese(num: solution)
            numText.text = "\(numToChinese(num: firstNum)) × \(numToChinese(num: secondNum)) = \(solutionText)"
        default:
            numText.text = "Unexpected language"
        }
    }
    
    // Note: Only works up to 2 digits
    func numToChinese(num: Int) -> String {
        switch (num) {
        case 0:
            return "零"
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "七"
        case 8:
            return "八"
        case 9:
            return "九"
        default:
            let tensPlace = num / 10
            let onesPlace = num % 10
            let tensPlaceText = if (tensPlace <= 1) { "" } else { numToChinese(num: tensPlace) }
            let onesPlaceText = if (onesPlace == 0) { "" } else { numToChinese(num: onesPlace) }
            return "\(tensPlaceText)十\(onesPlaceText)"
        }
    }
    
    func clear() {
        numText.text = ""
    }
    
    func setIncorrectColor() {
        numText.fontColor = .red
    }
    
    func setDefaultColor() {
        numText.fontColor = .white
    }
}
