//
//  Util.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import UIKit

class Util {
    static let marginPercent = 0.04
    
    static func windowHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static func windowWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static func width(percent: Double) -> CGFloat {
        return windowWidth() * percent
    }
    
    static func margin() -> CGFloat {
        return width(percent: marginPercent)
    }

}

enum NumberTypes: Int, CaseIterable {
    case one = 1, two, three, four, five, six, seven, eight, nine, zero = 0
}
enum ButtonTypes {
    case speedMode, accuracyMode, zenMode, settings
}

enum FrogType {
    case basic, wizard, boba, roundTongue, vampire, king, baby, spotted
    
    func file() -> String {
        switch (self) {
        case .basic:
            return "froggies_0007_basic"
        case .wizard:
            return "froggies_0000_wizard"
        case .boba:
            return "froggies_0001_boba"
        case .roundTongue:
            return "froggies_0002_round-tongue"
        case .vampire:
            return "froggies_0003_vampire"
        case .king:
            return "froggies_0004_king"
        case .baby:
            return "froggies_0005_baby"
        case .spotted:
            return "froggies_0006_spotted"
        }
    }
}

enum Difficulty {
    case easy, medium, hard
    
    // higher is faster
    func speed() -> CGFloat {
        switch(self) {
        case .easy:
            return 300
        case .medium:
            return 500
        case .hard:
            return 800
        }
    }
}
