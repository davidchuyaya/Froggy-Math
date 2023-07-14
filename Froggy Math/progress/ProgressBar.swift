//
//  ProgressBar.swift
//  Froggy Math
//
//  Created by David Chu on 6/16/23.
//

import SpriteKit

class ProgressBar: SKNode {
    static let widthPercent = 0.5
    static let topPercent = 0.12
    static let frogStageSizePercent = 0.1
    static let insetPercent = 0.01
    static let progressX = [0.0, 200.0, 326.0, 440.0, 550.0, 671.0, 818.0, 1037.0]
    static let animateSpeed = 2.0 // higher is slower
    
    var frog: ProgressFrog!
    var barFillMask: SKSpriteNode!
    var flyCounters = [ButtonTypes: FlyCounter]()
    
    init(frogStage: Int, fliesInAccuracyMode: Int, fliesInSpeedMode: Int, fliesInZenMode: Int, delegate: ProgressFrogDelegate?) {
        super.init()
        
        let barWidth = Util.width(percent: ProgressBar.widthPercent)
        let barHeight = barWidth / 1101 * 313 // based on picture dimensions
        let inset = Util.width(percent: ProgressBar.insetPercent)
        let flySize = Util.width(percent: Fly.sizePercent)
        let frogSize = barHeight + flySize + inset
        let frogHeight = frogSize * Frog.heightRatio
        
        // showing the frog stage or the unique chosen frog & positioning it
        if frogStage == 7 {
            frog = ProgressFrog(image: Settings.getLatestFrog().file(), size: CGSize(width: frogSize, height: frogSize * Frog.heightRatio), delegate: delegate)
        }
        else {
            frog = ProgressFrog(image: FrogStages.file(stage: frogStage), size: CGSize(width: frogSize, height: frogSize * Frog.heightRatio), delegate: delegate)
        }
        frog.position = CGPoint(x: Util.windowWidth() / 2 - (barWidth + frogSize + inset) / 2, y: Util.height(percent: 1 - ProgressBar.topPercent) - (frogHeight + barHeight + inset + flySize) / 2)
        addChild(frog)
        
        let bar = SKSpriteNode(texture: SKTexture(imageNamed: "progress_bar"), size: CGSize(width: barWidth, height: barHeight))
        bar.position = CGPoint(x: frog.position.x + frogSize + inset, y: Util.height(percent: 1 - ProgressBar.topPercent) - barHeight)
        bar.anchorPoint = CGPoint(x: 0, y: 0)
        bar.zPosition = 10
        addChild(bar)
        
        let barFillCrop = SKCropNode()
        barFillMask = SKSpriteNode(color: .white, size: CGSize(width: getBarFillWidth(frogStage: frogStage, flies: fliesInAccuracyMode + fliesInSpeedMode + fliesInZenMode), height: barHeight))
        barFillCrop.maskNode = barFillMask
        let barFill = SKSpriteNode(texture: SKTexture(imageNamed: "progress_bar_fill"), size: bar.size)
        barFillCrop.addChild(barFill)
        barFillMask.position = bar.position
        barFillMask.anchorPoint = bar.anchorPoint
        barFill.position = bar.position
        barFill.anchorPoint = bar.anchorPoint
        barFill.zPosition = bar.zPosition - 1
        addChild(barFillCrop)
        
        let flyCounterAccuracy = FlyCounter(type: .progress)
        flyCounterAccuracy.setCount(fliesInAccuracyMode)
        flyCounterAccuracy.position = CGPoint(x: bar.position.x + barWidth - flySize * 2.5 - inset * 2, y: bar.position.y - inset - flySize * 0.5)
        addChild(flyCounterAccuracy)
        flyCounters[.accuracyMode] = flyCounterAccuracy
        
        let flyCounterSpeed = FlyCounter(type: .progress)
        flyCounterSpeed.setCount(fliesInSpeedMode)
        flyCounterSpeed.position = CGPoint(x: bar.position.x + barWidth - flySize * 1.5 - inset, y: bar.position.y - inset - flySize * 0.5)
        addChild(flyCounterSpeed)
        flyCounters[.speedMode] = flyCounterSpeed
        
        let flyCounterZen = FlyCounter(type: .progress)
        flyCounterZen.setCount(fliesInZenMode)
        flyCounterZen.position = CGPoint(x: bar.position.x + barWidth - flySize * 0.5, y: bar.position.y - inset - flySize * 0.5)
        addChild(flyCounterZen)
        flyCounters[.zenMode] = flyCounterZen
        
        isUserInteractionEnabled = true
    }
    
    convenience init(delegate: ProgressFrogDelegate? = nil) {
        self.init(frogStage: Settings.getFrogStage(), fliesInAccuracyMode: Settings.getFliesInAccuracyMode(), fliesInSpeedMode: Settings.getFliesInSpeedMode(), fliesInZenMode: Settings.getFliesInZenMode(), delegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getBarFillWidth(frogStage: Int, flies: Int) -> CGFloat {
        var flyContribution = 0.0
        if frogStage + 1 < ProgressBar.progressX.count {
            let distanceToNext = ProgressBar.progressX[frogStage + 1] - ProgressBar.progressX[frogStage]
            flyContribution = Double(flies) / Double(FlyCounter.maxFlies * 3) * distanceToNext
        }
        return (ProgressBar.progressX[frogStage] + flyContribution) / 1101.0 * Util.width(percent: ProgressBar.widthPercent)
    }
    
    
    func animate(mode: ButtonTypes, modeDelta: Int, progressTotal: Int) {
        guard modeDelta > 0 else {
            return // nothing to animate (no changes)
        }
        
        barFillMask.run(SKAction.resize(toWidth: getBarFillWidth(frogStage: Settings.getFrogStage(), flies: progressTotal), duration: GameOverWindow.animateTime))
        flyCounters[mode]?.animateCountIncrement(modeDelta: modeDelta)
    }
    
    func getBottomY() -> CGFloat {
        return frog.position.y
    }
}
