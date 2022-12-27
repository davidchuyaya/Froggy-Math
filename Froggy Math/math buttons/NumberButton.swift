//
//  NumberButton.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit

class NumberButton: SKNode {
    static let insetSpacingPercent = 0.02
    var num: NumberTypes!
    var delegate: ButtonDelegate!
    
    init(num: NumberTypes, delegate: ButtonDelegate) {
        super.init()
        self.num = num
        self.delegate = delegate
        let numText = SKLabelNode(text: String(num.rawValue))
        numText.horizontalAlignmentMode = .center
        numText.verticalAlignmentMode = .center
        numText.color = UIColor.white
        numText.zPosition = 1
        
        let rect = SKSpriteNode(color: UIColor.blue, size: CGSize(width: NumberButton.getSize(), height: NumberButton.getSize()))
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        
        rect.addChild(numText)
        numText.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        addChild(rect)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.onButtonPressed(num: num)
    }
    
    static func getSize() -> Double {
        let screenSides = Util.marginPercent * 2
        let numButtons = 10.0
        let totalInsetSpacing = insetSpacingPercent * (numButtons - 1)
        let w =  Util.width(percent: (1-screenSides-totalInsetSpacing)/numButtons)
        return w
    }
}
