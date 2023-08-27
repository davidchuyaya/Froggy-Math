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

enum NumberStyles: String {
    case arabic, chinese
}

enum NumberTypes: Int, CaseIterable {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    func file(style: NumberStyles) -> String {
        switch (style) {
        case .arabic:
            return "\(self.rawValue)"
        case .chinese:
            return "\(self.rawValue)_zh"
        }
    }
}
enum ButtonTypes {
    case speedMode, accuracyMode, zenMode, settings, home, pause, resume, end, back, replay, enter, clear, ok, next, prev, froggies
    func file() -> String {
        return "\(self)"
    }
}
enum FlyTypes {
    case toLeaf, spiral, duel
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
    static func evolveText(newStage: Int, newFrog: FrogType? = nil) -> String {
        switch (newStage) {
        case 0:
            return "Congratulations!\nYou got a new frog egg!\nPlay some games to make it grow up!"
        case 1:
            return "You can see a baby frog inside the frog egg!"
        case 2:
            return "Your frog egg hatched into a tiny tadpole!"
        case 3:
            return "Your tadpole grew a tail!"
        case 4:
            return "Your tadpole grew some hind feet!"
        case 5:
            return "Your tadpole grew some hands!"
        case 6:
            return "Your tadpole's tail shrunk!"
        case 7:
            if let newFrog = newFrog {
                return "Your tadpole became a \(newFrog.name())!"
            }
            else {
                return "Code error. No new frog was chosen"
            }
        default:
            return "Code error. Unexpected frog stage"
        }
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

enum FrogType: String, CaseIterable {
    case basic = "froggies_0007_basic"
    case wizard = "froggies_0000_wizard"
    case boba = "froggies_0001_boba"
    case roundTongue = "froggies_0002_round-tongue"
    case vampire = "froggies_0003_vampire"
    case king = "froggies_0004_king"
    case baby = "froggies_0005_baby"
    case spotted = "froggies_0006_spotted"
    
    func file() -> String {
        return rawValue
    }
    
    func name() -> String {
        switch (self) {
        case .basic:
            return "basic frog"
        case .wizard:
            return "wizard frog"
        case .boba:
            return "boba frog"
        case .roundTongue:
            return "round tongue frog"
        case .vampire:
            return "vampire frog"
        case .king:
            return "frog king"
        case .baby:
            return "baby frog"
        case .spotted:
            return "spotted frog"
        }
    }
}

