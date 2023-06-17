//
//  FlyCounter.swift
//  Froggy Math
//
//  Created by David Chu on 6/15/23.
//

import SpriteKit

class FlyCounter: SKNode {
    static let withTextSizePercent = 0.1
    static let flySizePercent = 0.06
    
    static let maxFlies = 30
    
    var type: FlyCounterTypes!
    var flyPic: SKSpriteNode!
    var flyMask: SKSpriteNode?
    var label: SKLabelNode?
    var count: Int?
    
    init(type: FlyCounterTypes) {
        super.init()
        
        self.type = type
        
        let rect = SKSpriteNode()
        rect.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let flySize = Util.width(percent: FlyCounter.flySizePercent)
        flyPic = SKSpriteNode(texture: SKTexture(imageNamed: "flies_0001_Layer-1"), size: CGSize(width: flySize, height: flySize))
        rect.addChild(flyPic)
        
        switch (type) {
        case .progress:
            let flyCrop = SKCropNode()
            flyCrop.zPosition = flyPic.zPosition + 1
            flyMask = SKSpriteNode(color: .white, size: CGSize(width: 0, height: flySize))
            flyCrop.maskNode = flyMask
            let flyPic2 = SKSpriteNode(texture: SKTexture(imageNamed: "flies_0001_Layer-1"), size: CGSize(width: flySize, height: flySize))
            flyCrop.addChild(flyPic2)
            rect.addChild(flyCrop)
        case .numbered:
            label = SKLabelNode()
            label!.horizontalAlignmentMode = .center
            label!.verticalAlignmentMode = .center
            label!.fontSize = Util.fontSizeSmall
            label!.fontName = Util.font
            label!.fontColor = .white
            label!.zPosition = 5
            rect.addChild(label!)
        case .normal:
            break
        }
        
        addChild(rect)
        setColorNeutral()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setColorNeutral() {
        flyPic.color = .black
        flyPic.colorBlendFactor = 1.0
    }
    
    func setColorFailed() {
        flyPic.color = .red
        flyPic.colorBlendFactor = 0.7
    }
    
    func setColorSucceeded() {
        flyPic.colorBlendFactor = 0.0
    }
    
    func setCount(_ count: Int) {
        self.count = count
        
        if let label = label {
            label.text = "\(count)"
        }
        if let flyMask = flyMask {
            let flySize = Util.width(percent: FlyCounter.flySizePercent)
            let percentWidth = Double(count / FlyCounter.maxFlies)
            flyMask.size = CGSize(width: percentWidth * flySize, height: flySize)
        }
    }
    
    func animateCountIncrement(solvedFlies: Int) {
        guard solvedFlies > 0 else {
            return
        }
        guard count != nil else {
            print("FlyCounter attempted to animate without setting initial count")
            return
        }
        guard flyMask != nil else {
            print("FlyCounter attempted to animate without creating mask")
            return
        }
        
        let flySize = Util.width(percent: FlyCounter.flySizePercent)
        let percentWidth = Double((count! + solvedFlies) / FlyCounter.maxFlies)
        
        flyMask!.run(SKAction.resize(toWidth: percentWidth * flySize, duration: GameOverWindow.animateTime))
    }
}
