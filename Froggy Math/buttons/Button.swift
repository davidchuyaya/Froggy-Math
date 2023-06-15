//
//  Button.swift
//  Froggy Math
//
//  Created by David Chu on 1/8/23.
//

import SpriteKit

class Button: SKNode {
    static let sizePercent = 0.3
    static let randomWarpDelta: Float = 0.03 // higher is more warp
    static let warpSpeed = 1.2 // lower is faster
    static let clickScale = 1.1
    
    var delegate: ButtonDelegate!
    var type: ButtonTypes!
    var rect: SKSpriteNode!

    init(type: ButtonTypes, center: Bool, delegate: ButtonDelegate) {
        super.init()
        self.type = type
        self.delegate = delegate
        
        rect = SKSpriteNode(texture: SKTexture(imageNamed: type.file()), size: CGSize(width: Util.width(percent: Button.sizePercent), height: Util.width(percent: Button.sizePercent)))
        if center {
            rect.anchorPoint = CGPoint(x: 0.5, y: 0)
        }
        else {
            rect.anchorPoint = CGPoint(x: 0, y: 0)
        }
        
        addChild(rect)
        isUserInteractionEnabled = true
        
        startRandomWarp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        }
        
        let wait = SKAction.wait(forDuration: Button.warpSpeed)
        
        rect.run(SKAction.repeatForever(SKAction.sequence([randomWarp, wait])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rect.setScale(Button.clickScale)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rect.setScale(1)
        delegate.onButtonPressed(button: type)
    }
}
