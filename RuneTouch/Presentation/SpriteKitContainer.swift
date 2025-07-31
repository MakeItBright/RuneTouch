//
//  SpriteKitContainer.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//
//  UIViewRepresentable for SKView

import SwiftUI
import SpriteKit

struct SpriteKitContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}
