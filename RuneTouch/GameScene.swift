//
//  GameScene.swift
//  RuneTouch
//
//  Created by Juri Breslauer on 7/30/25.
//
import SpriteKit
import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black

        let label = SKLabelNode(text: "RuneTouch")
        label.fontName = "AvenirNext-Bold" // можешь поменять шрифт
        label.fontSize = 48
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)

        addChild(label)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if let label = children.first(where: { $0 is SKLabelNode }) {
            label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }
}


