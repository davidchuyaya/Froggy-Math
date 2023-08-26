//
//  Background.swift
//  Froggy Math
//
//  Created by David Chu on 8/26/23.
//

import SpriteKit

class Background {
    static func addBackground(scene: SKScene, num: Int) {
        // Assume all backgrounds are 828 x 1792
        let background = SKSpriteNode(imageNamed: "background\(num)")
        background.size = CGSize(width: scene.frame.width, height: 1792.0 / 828.0 * scene.frame.width)
        background.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        scene.addChild(background)
    }
}

