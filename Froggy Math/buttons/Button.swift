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
        
        var color: UIColor!
        switch (type) {
        case .speedMode:
            color = .blue
        case .accuracyMode:
            color = .red
        case .zenMode:
            color = .yellow
        case .home:
            color = .green
        case .enter:
            color = .white
        default:
            print("button type not handled")
        }
        
        let rect = SKSpriteNode(color: color, size: CGSize(width: Util.width(percent: Button.sizePercent), height: Util.width(percent: Button.sizePercent)))
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
