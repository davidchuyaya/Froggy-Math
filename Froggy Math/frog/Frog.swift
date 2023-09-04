//
//  Frog.swift
//  Froggy Math
//
//  Created by David Chu on 12/26/22.
//

import SpriteKit

class Frog: SKNode {
    static let tongueSpeed = 0.03 //lower is faster
    static let sizePercent = 0.7
    static let heightRatio = 0.75

    var delegate: FrogDelegate?
    var frog: SKSpriteNode!
    var slurpSoundActions = [SKAction]()
    
    init(type: FrogType, size: CGSize? = nil, loadSounds: Bool, delegate: FrogDelegate? = nil) {
        super.init()
        
        self.delegate = delegate
        
        let frogSize = size ?? CGSize(width: Frog.getWidth(), height: Frog.getHeight())
        frog = SKSpriteNode(texture: SKTexture(imageNamed: type.file()), size: frogSize)
        frog.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(frog)
        isUserInteractionEnabled = true
        
        // set up sounds. Load them before we use them to avoid audio lag
        if loadSounds {
            for file in Sounds.slurp.files() {
                slurpSoundActions.append(SKAction.playSoundFileNamed(file, waitForCompletion: false))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onFrogPressed()
    }
    
    func setNewType(_ type: FrogType) {
        frog.texture = SKTexture(imageNamed: type.file())
    }
    
    func setColorSilhouette() {
        frog.color = .black
        frog.colorBlendFactor = 1.0
    }
    
    static func getWidth() -> Double {
        return Util.width(percent: sizePercent)
    }
    
    static func getHeight() -> Double {
        return Frog.getWidth() * Frog.heightRatio
    }
    
    func tongue(to fly: CGPoint) {
        // magic numbers obtained from photoshop
        let x: CGFloat = Frog.getWidth()/800*351
        let y: CGFloat = Frog.getWidth()/800*170
        let xDiff: CGFloat!
        let yDiff: CGFloat!
        let angle: CGFloat!
        if zRotation == 0 {
            xDiff = fly.x - (position.x + x)
            yDiff = fly.y - (position.y + y)
            angle = atan2(yDiff, xDiff) - Double.pi/2
        }
        else { // assume either frog is right side up or rotated 180
            xDiff = fly.x - (position.x - x)
            yDiff = fly.y - (position.y - y)
            angle = atan2(yDiff, xDiff) - Double.pi * 1.5
        }
        let distance = sqrt(xDiff*xDiff + yDiff*yDiff)
        
        let mouth = SKSpriteNode(texture: SKTexture(imageNamed: "mouth") , size: CGSize(width: Frog.getWidth()/800*130, height: Frog.getWidth()/800*72))
        mouth.anchorPoint = CGPoint(x: 0, y: 0)
        mouth.position = CGPoint(x: Frog.getWidth()/800*286, y: Frog.getWidth()/800*151)
        mouth.zPosition = 1
        mouth.isUserInteractionEnabled = false
        addChild(mouth)
        
        let tongue = SKSpriteNode(color: .black, size: CGSize(width: Frog.getWidth()/800*112, height: distance))
        tongue.anchorPoint = CGPoint(x: 0.5, y: 0)
        tongue.position = CGPoint(x: x, y: y)
        tongue.zPosition = 2
        tongue.zRotation = angle
        tongue.isUserInteractionEnabled = false
        
        let short = SKTexture(imageNamed: "tongue_0001_Layer-3")
        let mid = SKTexture(imageNamed: "tongue_0002_Layer-2")
        let long = SKTexture(imageNamed: "tongue_0000_Layer-1")
        let frames = [short, mid, long, mid, short]
        addChild(tongue)
        
        let remove = SKAction.run {
            mouth.removeFromParent()
            tongue.removeFromParent()
        }
        
        let tongueAction = SKAction.sequence([SKAction.animate(with: frames, timePerFrame: Frog.tongueSpeed), remove])
        let slurpSound = slurpSoundActions.randomElement()!
        
        tongue.run(SKAction.group([tongueAction, slurpSound]))
    }
}

