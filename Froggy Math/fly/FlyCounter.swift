//
//  FlyCounter.swift
//  Froggy Math
//
//  Created by David Chu on 6/15/23.
//

import SpriteKit

class FlyCounter: SKNode {
    
    var label: SKLabelNode!
    
    override init() {
        super.init()
        
        let rect = SKSpriteNode()
        rect.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let fly = Fly(type: .still, center: true, difficulty: .easy, delegate: nil)
        rect.addChild(fly)
        
        label = SKLabelNode()
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = Util.fontSizeSmall
        label.fontName = Util.font
        label.fontColor = .white
        label.zPosition = 5
        rect.addChild(label)
        
        addChild(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCount(_ count: Int) {
        label.text = "\(count)"
    }
}
