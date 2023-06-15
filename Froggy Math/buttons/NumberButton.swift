//
//  NumberButton.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit

class NumberButton: SKNode {
    static let insetSpacingPercent = 0.0
    var num: NumberTypes!
    var delegate: NumberButtonDelegate!
    
    init(num: NumberTypes, delegate: NumberButtonDelegate) {
        super.init()
        self.num = num
        self.delegate = delegate
        
        let rect = SKSpriteNode(texture: SKTexture(imageNamed: num.file()), size: CGSize(width: NumberButton.getSize(), height: NumberButton.getSize()))
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        rect.zPosition = 100
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
