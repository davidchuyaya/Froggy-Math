//
//  AlertWindow.swift
//  Froggy Math
//
//  Created by David Chu on 6/13/23.
//

import SpriteKit

class AlertWindow: SKNode, ButtonDelegate {
    static let imageWidthPercent = 0.5
    static let font = "Noteworthy-Light"
    static let fontSize: CGFloat = 36
    static let numberOfLines = 2
    
    var delegate: ButtonDelegate?
    var image: SKSpriteNode!
    var label: SKLabelNode!
    var buttons = [Button]()
    
    init(imageFile: String, text: String, buttonTypes: [ButtonTypes], delegate: ButtonDelegate?) {
        super.init()
        
        self.delegate = delegate
        
        let halfNumButtons = Double(buttonTypes.count) / 2.0
        // coordinate origin is at bottom left
        for (i, type) in buttonTypes.enumerated() {
            let button = Button(type: type, center: true, delegate: self)
            // center button x should be 0, if there is an odd number
            let distanceFromMid = halfNumButtons - Double(i)
            let x = (0.5 - distanceFromMid) * (Util.width(percent: Button.sizePercent + Util.marginPercent))
            button.position = CGPoint(x: x, y: Util.margin())
            button.zPosition = 201
            buttons.append(button)
        }
        
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
        
        image = SKSpriteNode(texture: SKTexture(imageNamed: imageFile), size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent), height: Util.width(percent: AlertWindow.imageWidthPercent)))
//        image = SKSpriteNode(color: .blue, size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent), height: Util.width(percent: AlertWindow.imageWidthPercent)))
        image.anchorPoint = CGPoint(x: 0.5, y: 0)
        image.position = CGPoint(x: 0, y: Util.width(percent: Button.sizePercent + Util.marginPercent * 3) + labelHeight)
        image.zPosition = 201

        let bg = SKSpriteNode(color: .white, size: CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent + Util.marginPercent * 2), height: Util.width(percent: AlertWindow.imageWidthPercent + Button.sizePercent + Util.marginPercent * 4) + labelHeight))
        bg.anchorPoint = CGPoint(x: 0.5, y: 0)
        bg.zPosition = 200
        addChild(bg)
        
        bg.addChild(image)
        bg.addChild(label)
        for button in buttons {
            bg.addChild(button)
        }
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
        delegate?.onButtonPressed(button: button)
        removeFromParent()
    }
}
