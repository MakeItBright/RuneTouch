//
//  GameView.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//
//  SwiftUI wrapper for SpriteKit

import SwiftUI
import SpriteKit

public struct GameView: View {
    // 👇 добавим callback
    public var onExit: (() -> Void)?

    public init(onExit: (() -> Void)? = nil) {
        self.onExit = onExit
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            SpriteView(scene: {
                let scene = GameScene(size: UIScreen.main.bounds.size)
                scene.scaleMode = .resizeFill
                return scene
            }())
            .ignoresSafeArea()

            Button(action: {
                onExit?()
            }) {
                Text("✖️ Назад")
                    .padding(10)
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .font(.headline)
            }
            .padding()
        }
    }
}

#Preview("GameView") {
    GameView()
}
