//
//  AlertWindow.swift
//  Froggy Math
//
//  Created by David Chu on 6/13/23.
//

import SpriteKit

class AlertWindow: SKNode, ButtonDelegate {
    static let imageWidthPercent = 0.5
    static let yMarginPercent = 0.1
    
    var delegate: ButtonDelegate?
    var label: SKLabelNode!
    var buttons = [Button]()
    
    init(image: SKNode?, text: String, buttonTypes: [ButtonTypes], delegate: ButtonDelegate?) {
        super.init()
        
        self.delegate = delegate
        
        let halfNumButtons = Double(buttonTypes.count) / 2.0
        // coordinate origin is at bottom left
        for (i, type) in buttonTypes.enumerated() {
            let button = Button(type: type, delegate: self)
            // center button x should be -0.5 * button size, if there is an odd number
            let distanceFromMid = halfNumButtons - Double(i)
            let x = (0.5 - distanceFromMid) * (Util.width(percent: Button.sizePercent + Util.marginPercent)) - Util.width(percent: Button.sizePercent * 0.5)
            button.position = CGPoint(x: x, y: Util.width(percent: AlertWindow.yMarginPercent))
            button.zPosition = 201
            buttons.append(button)
        }
        
        label = SKLabelNode()
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.fontSize = Util.fontSize
        label.fontName = Util.font
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = Util.width(percent: 1 - Util.marginPercent * 2)
        label.position = CGPoint(x: 0, y: Util.windowHeight() / 2)
        label.fontColor = .black
        label.zPosition = 201
        label.text = text

        let bg = SKSpriteNode(color: .white, size: CGSize(width: Util.windowWidth(), height: Util.windowHeight()))
        bg.anchorPoint = CGPoint(x: 0.5, y: 0)
        bg.zPosition = 200
        addChild(bg)
        
        if image != nil {
            bg.addChild(image!)
        }
        bg.addChild(label)
        for button in buttons {
            bg.addChild(button)
        }
        
        position = CGPoint(x: Util.windowWidth() / 2, y: 0)
    }
    
    convenience init(imageFile: String, size: CGSize, text: String, buttonTypes: [ButtonTypes], delegate: ButtonDelegate?) {
        let image = SKSpriteNode(texture: SKTexture(imageNamed: imageFile), size: size)
        image.anchorPoint = CGPoint(x: 0.5, y: 1)
        image.position = CGPoint(x: 0, y: Util.height(percent: 1 - AlertWindow.yMarginPercent))
        image.zPosition = 201
        
        self.init(image: image, text: text, buttonTypes: buttonTypes, delegate: delegate)
    }
    
    convenience init(imageFile: String, text: String, buttonTypes: [ButtonTypes], delegate: ButtonDelegate?) {
        let size = CGSize(width: Util.width(percent: AlertWindow.imageWidthPercent), height: Util.width(percent: AlertWindow.imageWidthPercent))
        self.init(imageFile: imageFile, size: size, text: text, buttonTypes: buttonTypes, delegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onButtonPressed(button: ButtonTypes) {
        delegate?.onButtonPressed(button: button)
        removeFromParent()
    }
}
