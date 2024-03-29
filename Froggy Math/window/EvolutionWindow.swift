//
//  EvolutionWindow.swift
//  Froggy Math
//
//  Created by David Chu on 6/17/23.
//

import SpriteKit

class EvolutionWindow: AlertWindow {
    convenience init(frogStage: Int, newFrog: FrogType? = nil, delegate: ButtonDelegate? = nil) {
        let imageFile: String
        if frogStage != 7 {
            imageFile = FrogStages.file(stage: frogStage)
        }
        else {
            if let newFrog = newFrog {
                imageFile = newFrog.file()
            }
            else {
                print("Expected new frog in evolution window")
                imageFile = FrogStages.file(stage: 0)
            }
        }
        
        let width = Util.width(percent: AlertWindow.imageWidthPercent)
        let size = CGSize(width: width, height: width * Frog.heightRatio)
        
        self.init(imageFile: imageFile, size: size, text: FrogStages.evolveText(newStage: frogStage, newFrog: newFrog), buttonTypes: [.home], delegate: delegate)
    }
}
