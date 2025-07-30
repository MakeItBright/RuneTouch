//
//  GameView.swift
//  RuneTouch
//
//  Created by Juri Breslauer on 7/30/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            SpriteView(scene: makeScene(size: size))
                .ignoresSafeArea()
        }
    }

    func makeScene(size: CGSize) -> SKScene {
        let scene = GameScene()
        scene.size = size
        scene.scaleMode = .aspectFit
        return scene
    }
}
#Preview {
    GameView()
}
