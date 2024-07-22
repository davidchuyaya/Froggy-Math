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
    var language: NumberStyles!
    var numDelegate: NumberButtonDelegate?
    var languageDelegate: LanguageButtonDelegate?
    var isLanguageButton: Bool!
    
    init(num: NumberTypes, style: NumberStyles, numDelegate: NumberButtonDelegate? = nil, languageDelegate: LanguageButtonDelegate? = nil) {
        super.init(imageFile: num.file(style: style), size: Util.width(percent: NumberButton.numButtonSizePercent), delegate: nil)
        
        self.num = num
        self.language = style
        self.numDelegate = numDelegate
        self.languageDelegate = languageDelegate
        isLanguageButton = languageDelegate != nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func onButtonPressed() {
        if isLanguageButton {
            languageDelegate?.onButtonPressed(language: language)
        }
        else {
            numDelegate?.onButtonPressed(num: num)
        }
    }
    
    func setInactiveColor() {
        rect.color = .black
        rect.colorBlendFactor = 0.8
    }
}
