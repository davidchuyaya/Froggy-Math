//
//  Button.swift
//  Froggy Math
//
//  Created by David Chu on 1/8/23.
//

import SpriteKit

class Button: SKNode {
    static let sizePercent = 0.1
    var delegate: ButtonDelegate!
    var type: ButtonTypes!
    
    init(type: ButtonTypes, delegate: ButtonDelegate) {
        super.init()
        self.type = type
        self.delegate = delegate
        
        let rect = SKSpriteNode(color: UIColor.blue, size: CGSize(width: Util.width(percent: Button.sizePercent), height: Util.width(percent: Button.sizePercent)))
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        
        addChild(rect)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.onButtonPressed(button: type)
    }
}
