//
//  Log.swift
//  Froggy Math
//
//  Created by David Chu on 8/26/23.
//

import SpriteKit

class Log: SKNode, FrogDelegate {
    static let logWidthPercent = 0.5
    static let logWidthToHeightRatio = 613.0/825.0
    static let buttShadowWidthPercent = 0.3
    static let buttShadowHeightPercent = 0.1
    static let buttShadowOpacity = 0.3
    static let wobbleSpeed = 0.2 // lower is faster
    static let wobbleAngle = 0.1 // higher is more wobble
    static let floatSpeed = 3.0 // lower is faster
    
    var log: SKSpriteNode!
    var frogButtShadow: SKShapeNode?
    var frog: Frog?
    
    init(type: FrogType? = nil, animate: Bool) {
        super.init()
        
        let logWidth = Util.width(percent: Log.logWidthPercent)
        let logHeight = logWidth * Log.logWidthToHeightRatio
        log = SKSpriteNode(texture: SKTexture(imageNamed: "log"), size: CGSize(width: logWidth, height: logHeight))
        log.zPosition = 1
        addChild(log)
        
        if let actualType = type ?? Settings.getFrogs().randomElement() {
            // add shadow for frog
            let buttShadowWidth = Frog.getWidth() * Log.buttShadowWidthPercent
            let buttShadowHeight = Frog.getHeight() * Log.buttShadowHeightPercent
            frogButtShadow = SKShapeNode(ellipseIn: CGRect(x: -buttShadowWidth / 2.7, y: buttShadowHeight * 0.4, width: buttShadowWidth, height: buttShadowHeight))
            frogButtShadow!.fillColor = .black
            frogButtShadow!.alpha = Log.buttShadowOpacity
            frogButtShadow!.lineWidth = 0
            frogButtShadow!.zPosition = 2
            addChild(frogButtShadow!)
            
            frog = Frog(type: actualType, loadSounds: false, delegate: self)
            frog!.position = CGPoint(x: -Frog.getWidth() / 2.2, y: Frog.getHeight() * 0.05)
            frog!.zPosition = 3
            addChild(frog!)
        }
        
        // Animate floating
        if animate {
            let floatRight = SKAction.moveBy(x: Util.width(percent: 0.6), y: 0, duration: Log.floatSpeed)
            floatRight.timingMode = .easeInEaseOut
            run(SKAction.repeatForever(SKAction.sequence([floatRight, floatRight.reversed()])))
        }

        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onFrogPressed() {
        let rotate = SKAction.rotate(byAngle: Log.wobbleAngle, duration: Log.wobbleSpeed)
        run(SKAction.repeat(SKAction.sequence([rotate, rotate.reversed()]), count: 2))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onFrogPressed()
    }
}
