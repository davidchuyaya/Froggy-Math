//
//  ProgressFrog.swift
//  Froggy Math
//
//  Created by David Chu on 6/17/23.
//

import SpriteKit

class ProgressFrog: SKNode {
    var frog: SKSpriteNode!
    var delegate: ProgressFrogDelegate?
    
    init(image: String, size: CGFloat, delegate: ProgressFrogDelegate?) {
        super.init()
        // todo: Animate if there is a delegate (so the user knows to click)
        
        self.delegate = delegate
        
        frog = SKSpriteNode(texture: SKTexture(imageNamed: image), size: CGSize(width: size, height: size))
        frog.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(frog)
        
        isUserInteractionEnabled = (delegate != nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        frog.setScale(Button.clickScale)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        frog.setScale(1.0)
        delegate?.onProgressFrogPressed()
    }
}
