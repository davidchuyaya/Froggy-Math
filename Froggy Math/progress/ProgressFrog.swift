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
    
    init(image: String, size: CGSize, delegate: ProgressFrogDelegate?) {
        super.init()
        
        self.delegate = delegate
        if delegate != nil {
            let sparks = SKEmitterNode(fileNamed: "LightRaysParticle")!
            sparks.position = CGPoint(x: size.width / 2, y: size.height / 2)
            sparks.zPosition = 201
            addChild(sparks)
        }
        
        frog = SKSpriteNode(texture: SKTexture(imageNamed: image), size: size)
        frog.anchorPoint = CGPoint(x: 0, y: 0)
        frog.zPosition = 202
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
