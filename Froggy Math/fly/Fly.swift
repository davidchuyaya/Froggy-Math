//
//  Fly.swift
//  Froggy Math
//
//  Created by David Chu on 12/26/22.
//

import SpriteKit

class Fly: SKNode {
    static let xMarginPercent = 0.4
    static let sizePercent = 0.1
    static let moveDistance = 5.0
    static let screenBottom: CGFloat = 100
    static let loopVariation: CGFloat = 10 // higher = more diverse sizes of loops, might go off screen though
    static let numLoops = 4
    var type: ButtonTypes!
    var difficulty: Difficulty!
    var delegate: FlyDelegate!
    var flyPic: SKSpriteNode!
    var wingsUpTexture: SKTexture!
    
    init(type: ButtonTypes, difficulty: Difficulty, delegate: FlyDelegate) {
        super.init()
        
        self.type = type
        self.difficulty = difficulty
        self.delegate = delegate
        
        wingsUpTexture = SKTexture(imageNamed: "flies_0000_Layer-2")
        let frame2 = SKTexture(imageNamed: "flies_0001_Layer-1")
        
        flyPic = SKSpriteNode(texture: wingsUpTexture, size: CGSize(width: Fly.getSize(), height: Fly.getSize()))
        flyPic.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(flyPic)
        flyPic.zPosition = 2
        
        flyPic.run(SKAction.repeatForever(SKAction.animate(with: [wingsUpTexture, frame2], timePerFrame: 0.1)))
        createPaths()
    }
    
    func createPaths() {
        switch (type) {
        case .speedMode:
            followSpiralPath()
        case .zenMode:
            fallthrough
        case .accuracyMode:
            followPathToLeaf()
        default:
            print("type deosn't exist for fly")
        }
    }
    
    func followSpiralPath() {
        let clockwise = Bool.random()
        let path = UIBezierPath()
        let startingX = CGFloat.random(in: Util.width(percent: Fly.xMarginPercent)..<Util.width(percent: 1-Fly.xMarginPercent))
        path.move(to: CGPoint(x: startingX, y: Util.height(percent: 1+Fly.sizePercent)))
        
        var prevTopY = Util.windowHeight()
        for i in 0..<Fly.numLoops {
            let lastLoop = i == Fly.numLoops - 1
            prevTopY = addLoopTo(path, x: startingX, topY: prevTopY, clockwise: clockwise, lastLoop: lastLoop)
        }
        
        let notifyParent = SKAction.run {
            self.delegate.flyReachedBottom()
        }
        
        run(SKAction.sequence([SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: difficulty.speed()), notifyParent]))
    }
    
    // returns new starting Y after the loop
    func addLoopTo(_ path: UIBezierPath, x: CGFloat, topY: CGFloat, clockwise: Bool, lastLoop: Bool) -> CGFloat {
        // control the size of the loops. x1.5 because the the flies go halfway back up each loop
        let loopAvgSize = (Util.windowHeight() - Fly.screenBottom) / CGFloat(Fly.numLoops) * 1.5
        let loopDiff = CGFloat.random(in: -Fly.loopVariation..<Fly.loopVariation)
        var bottomY = topY - (loopAvgSize + loopDiff)
        if (bottomY - Fly.getSize() * 2) < Fly.screenBottom || lastLoop { // add some padding at bottom so fly doesn't dip out of existence
            bottomY = Fly.screenBottom
        }
        
        let cpXDif1 = (topY - bottomY) * 0.75
        let cpx1 = clockwise ? (x + cpXDif1) : (x - cpXDif1)
        path.addCurve(to: CGPoint(x: x, y: bottomY), controlPoint1: CGPoint(x: cpx1, y: topY), controlPoint2: CGPoint(x: cpx1, y: bottomY))
        
        // don't add bottom half of loop if it's the last one
        guard !lastLoop else {
            return bottomY
        }
        
        let midwayY = topY - (topY - bottomY) / 2
        let cpXDif2 = (midwayY - bottomY) * 0.75
        let cpx2 = clockwise ? (x - cpXDif2) : (x + cpXDif2)
        path.addCurve(to: CGPoint(x: x, y: midwayY), controlPoint1: CGPoint(x: cpx2, y: bottomY), controlPoint2: CGPoint(x: cpx2, y: midwayY))
        
        return midwayY
    }
    
    func followPathToLeaf() {
        let path = CGMutablePath()
        let destX = Util.width(percent: 1 - BattleScene.leafWidthPercent/3*2)
        let destY = Util.height(percent: 1 - BattleScene.leafYPercent/5*2)
        path.move(to: CGPoint(x: -Util.width(percent: 0.1), y: destY + Util.height(percent: 0.1)))
        path.addLine(to: CGPoint(x: destX, y: destY))
        
        let pause = SKAction.run {
            self.flyPic.isPaused = true
            self.flyPic.texture = self.wingsUpTexture
        }
        
        run(SKAction.sequence([SKAction.follow(path, asOffset: false, orientToPath: false, speed: difficulty.speed()), pause]))
    }
    
    func exit() {
        let path = CGMutablePath()
        let destX = Util.width(percent: 1.1)
        let destY = Util.height(percent: 1 - BattleScene.leafYPercent/5*2)
        path.move(to: position)
        path.addLine(to: CGPoint(x: destX, y: destY + Util.height(percent: 0.1)))
        
        flyPic.isPaused = false
        run(SKAction.sequence([SKAction.follow(path, asOffset: false, orientToPath: false, speed: difficulty.speed()), SKAction.removeFromParent()]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getSize() -> Double {
        return Util.width(percent: sizePercent)
    }
}
