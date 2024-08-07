//
//  ButtonDelegate.swift
//  Froggy Math
//
//  Created by David Chu on 12/23/22.
//

import Foundation

protocol NumberButtonDelegate {
    func onButtonPressed(num: NumberTypes)
}
protocol LanguageButtonDelegate {
    func onButtonPressed(language: NumberStyles)
}
protocol ButtonDelegate {
    func onButtonPressed(button: ButtonTypes)
}
