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
    case enter, backspace
}

enum FrogStages {
    case egg, tadpole, tadpoleWithFeet, frogWithTail, frog
}

enum GameType {
    case speed, accuracy, zen
}

enum Difficulty {
    case easy, medium, hard
    
    func timeBetweenProblems() -> Int {
        switch(self) {
        case .easy:
            return 5
        case .medium:
            return 3
        case .hard:
            return 1
        }
    }
}
