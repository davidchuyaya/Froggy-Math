//
//  NumberButton.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import SpriteKit

class NumberButton: Button {
    static let numButtonSizePercent = 0.16
    static let insetPercent = 0.03
    var num: NumberTypes!
    var numDelegate: NumberButtonDelegate!
    
    init(num: NumberTypes, style: NumberStyles, delegate: NumberButtonDelegate) {
        super.init(imageFile: num.file(style: style), size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: nil)
        
        self.num = num
        self.numDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func onButtonPressed() {
        numDelegate.onButtonPressed(num: num)
    }
    
    func setDisabledColor() {
        rect.color = .black
        rect.colorBlendFactor = 0.8
    }
}
