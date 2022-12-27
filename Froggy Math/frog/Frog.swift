//
//  Frog.swift
//  Froggy Math
//
//  Created by David Chu on 12/26/22.
//

import SpriteKit

class Frog: SKNode {
    static let sizePercent = 0.2
    var stage: FrogStages!
    var delegate: FrogDelegate!
    
    init(stage: FrogStages, delegate: FrogDelegate) {
        super.init()
        
        self.stage = stage
        self.delegate = delegate
        
        let rect = SKSpriteNode(color: UIColor.blue, size: CGSize(width: Frog.getSize(), height: Frog.getSize()))
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(rect)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.onFrogPressed()
    }
    
    static func getSize() -> Double {
        return Util.width(percent: sizePercent)
    }
}

