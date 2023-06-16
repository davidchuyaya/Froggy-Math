//
//  TimeBar.swift
//  Froggy Math
//
//  Created by David Chu on 6/15/23.
//

import SpriteKit

class TimeBar: SKNode {
    static let time = 60.0 // seconds
    static let widthPercent = 0.05
    
    var delegate: TimeBarDelegate!
    var height: CGFloat!
    var rect: SKSpriteNode!
    
    init(topY: CGFloat, bottomY: CGFloat, delegate: TimeBarDelegate) {
        super.init()
        
        self.delegate = delegate
        
        height = topY - bottomY
        rect = SKSpriteNode(color: .blue, size: CGSize(width: Util.width(percent: TimeBar.widthPercent), height: height))
        rect.anchorPoint = CGPoint(x: 0, y: 0)
        rect.position = CGPoint(x: Util.margin(), y: bottomY)
        addChild(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startTimer() {
        rect.size = CGSize(width: Util.width(percent: TimeBar.widthPercent), height: height)
        let barShrink = SKAction.resize(toHeight: 0, duration: TimeBar.time)
        rect.run(barShrink, completion: delegate.timeOut)
    }
}
