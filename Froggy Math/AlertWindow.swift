//
//  AlertWindow.swift
//  Froggy Math
//
//  Created by David Chu on 6/13/23.
//

import SpriteKit

class AlertWindow: SKNode, ButtonDelegate {
    static let imageWidthPercent = 0.5
    static let font = "AppleSDGothicNeo-Regular"
    static let fontSize: CGFloat = 36
    static let numberOfLines = 2
    
    var image: SKSpriteNode!
    var label: SKLabelNode!
    var okButton: Button!
    
    init(imageFile: String, text: String) {
        super.init()
        
        // coordinate origin is at bottom left
        okButton = Button(type: .ok, center: true, delegate: self)
        okButton.position = CGPoint(x: 0, y: Util.margin())
        okButton.zPosition = 201
        
        label = SKLabelNode()
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.fontSize = AlertWindow.fontSize
        label.fontName = AlertWindow.font
        label.numberOfLines = AlertWindow.numberOfLines
        label.preferredMaxLayoutWidth = Util.width(percent: AlertWindow.imageWidthPercent - Util.marginPercent * 2)
        let labelHeight = labelHeight() * CGFloat(AlertWindow.numberOfLines)
        label.position = CGPoint(x: 0, y: Util.width(percent: Button.sizePercent + Util.marginPercent * 2) + labelHeight)
        label.fontColor = .black
        label.zPosition = 201
        label.text = text
        
//        image = SKSpriteNode(texture: SKTexture(imageNamed: imageFile), size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent), height: Util.width(percent: AlertWindow.imageWidthPercent)))
        image = SKSpriteNode(color: .blue, size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent), height: Util.width(percent: AlertWindow.imageWidthPercent)))
        image.anchorPoint = CGPoint(x: 0.5, y: 0)
        image.position = CGPoint(x: 0, y: Util.width(percent: Button.sizePercent + Util.marginPercent * 3) + labelHeight)
        image.zPosition = 201

        let bg = SKSpriteNode(color: .white, size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent + Util.marginPercent * 2), height: Util.width(percent: AlertWindow.imageWidthPercent + Button.sizePercent + Util.marginPercent * 4) + labelHeight))
        bg.anchorPoint = CGPoint(x: 0.5, y: 0)
        bg.zPosition = 200
        addChild(bg)
        
        bg.addChild(image)
        bg.addChild(label)
        bg.addChild(okButton)
        // for some reason centering bg on y-axis doesn't center its children, so we have to do a little math
        position = CGPoint(x: Util.windowWidth() / 2, y: Util.windowHeight() / 2 - bg.size.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelHeight() -> CGFloat {
        let font = UIFont(name: AlertWindow.font, size: AlertWindow.fontSize)
        return font!.lineHeight
    }
    
    func onButtonPressed(button: ButtonTypes) {
        removeFromParent()
    }
}
