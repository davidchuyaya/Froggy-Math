//
//  Util.swift
//  Froggy Math
//
//  Created by David Chu on 12/15/22.
//

import UIKit

class Util {
    static let marginPercent = 0.04
    static let font = "Noteworthy-Light"
    static let fontSize: CGFloat = 36
    static let fontSizeSmall: CGFloat = 12
    
    static func windowHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static func windowWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static func width(percent: Double) -> CGFloat {
        return windowWidth() * percent
    }
    
    static func height(percent: Double) -> CGFloat {
        return windowHeight() * percent
    }
    
    static func margin() -> CGFloat {
        return width(percent: marginPercent)
    }

}

enum NumberTypes: Int, CaseIterable {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    func file() -> String {
        return "\(self.rawValue)"
    }
}
enum ButtonTypes {
    case speedMode, accuracyMode, zenMode, settings, home, pause, resume, back, replay, enter, clear, ok
    func file() -> String {
        return "\(self)"
    }
}
enum FlyTypes {
    case toLeaf, spiral
}
enum FlyCounterTypes {
    case normal, numbered, progress
}

enum Difficulty {
    case easy, medium, hard
    
    // higher is faster
    func speed() -> CGFloat {
        switch(self) {
        case .easy:
            return 200
        case .medium:
            return 400
        case .hard:
            return 800
        }
    }
}

class FrogStages {
    static func file(stage: Int) -> String {
        return "frog_stage_\(stage)"
    }
}

enum Sounds {
    case slurp
    
    func numFiles() -> Int {
        switch (self) {
        case .slurp:
            return 3
        }
    }
    
    func files() -> [String] {
        var fileNames = [String]()
        for i in 0..<numFiles() {
            fileNames.append("\(self)_\(i).m4a")
        }
        return fileNames
    }
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
