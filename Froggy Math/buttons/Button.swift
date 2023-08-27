//
//  Button.swift
//  Froggy Math
//
//  Created by David Chu on 1/8/23.
//

import SpriteKit

class Button: SKNode {
    static let sizePercent = 0.2
    static let randomWarpDelta: Float = 0.05 // higher is more warp
    static let warpSpeed = 1.2 // lower is faster
    static let clickScale = 1.1
    static let shadowScale = 1.1
    
    var delegate: ButtonDelegate?
    var type: ButtonTypes?
    var rect: SKSpriteNode!
    var shadow: SKSpriteNode!
    var size: CGFloat!

    // non-ButtonType button
    init(imageFile: String, size: CGFloat, delegate: ButtonDelegate?) {
        super.init()
        self.size = size
        self.delegate = delegate
        
        rect = SKSpriteNode(texture: SKTexture(imageNamed: imageFile), size: CGSize(width: size, height: size))
        shadow = SKSpriteNode(texture: SKTexture(imageNamed: imageFile), size: CGSize(width: size * Button.shadowScale, height: size * Button.shadowScale))
        shadow.color = .black
        shadow.colorBlendFactor = 1.0
        let anchorOffset = (Button.shadowScale - 1.0) / 2.0 / Button.shadowScale
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        shadow.anchorPoint = CGPoint(x: anchorOffset, y: anchorOffset)
        
        addChild(shadow)
        addChild(rect)
        zPosition = 1 // to prevent buttons from randomly not showing
        isUserInteractionEnabled = true
        
        startRandomWarp()
    }
    
    // custom width
    convenience init(type: ButtonTypes, size: CGFloat, delegate: ButtonDelegate) {
        self.init(imageFile: type.file(), size: size, delegate: delegate)
        self.type = type
    }
    
    // default button
    convenience init(type: ButtonTypes, delegate: ButtonDelegate) {
        self.init(type: type, size: Util.width(percent: Button.sizePercent), delegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startRandomWarp() {
        let src = [
            // bottom row: left, center, right
            vector_float2(0.0, 0.0),
            vector_float2(0.5, 0.0),
            vector_float2(1.0, 0.0),

            // middle row: left, center, right
            vector_float2(0.0, 0.5),
            vector_float2(0.5, 0.5),
            vector_float2(1.0, 0.5),

            // top row: left, center, right
            vector_float2(0.0, 1.0),
            vector_float2(0.5, 1.0),
            vector_float2(1.0, 1.0)
        ]
        
        let randomWarp = SKAction.run {
            var destPositions = [SIMD2<Float>]()
            for coords in src {
                let newX = coords.x + Float.random(in: -Button.randomWarpDelta..<Button.randomWarpDelta)
                let newY = coords.y + Float.random(in: -Button.randomWarpDelta..<Button.randomWarpDelta)
                destPositions.append(SIMD2<Float>(x: newX, y: newY))
            }
            
            let noWarpGrid = SKWarpGeometryGrid(columns: 2, rows: 2)
            let warpGrid = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: src, destinationPositions: destPositions)
            let action = SKAction.animate(withWarps: [warpGrid, noWarpGrid], times: [NSNumber(floatLiteral: Button.warpSpeed), NSNumber(floatLiteral: Button.warpSpeed * 2)])!
            
            self.rect.run(action)
            self.shadow.run(action)
        }
        
        let wait = SKAction.wait(forDuration: Button.warpSpeed)
        
        rect.run(SKAction.repeatForever(SKAction.sequence([randomWarp, wait])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rect.setScale(Button.clickScale)
        shadow.setScale(Button.clickScale)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rect.setScale(1)
        shadow.setScale(1)
        onButtonPressed()
    }
    
    func onButtonPressed() {
        if let delegate = delegate {
            if let type = type {
                delegate.onButtonPressed(button: type)
            }
        }
    }
    
    func setIncorrectColor() {
        rect.color = .red
        rect.colorBlendFactor = 0.8
        isUserInteractionEnabled = false
    }
    
    func setDisabledColor() {
        rect.color = .black
        rect.colorBlendFactor = 0.8
        isUserInteractionEnabled = false
    }
    
    func setDefaultColor() {
        rect.colorBlendFactor = 0.0
        isUserInteractionEnabled = true
    }
}
