//
//  GameView.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//
//  SwiftUI wrapper for SpriteKit

import Foundation
import SwiftUI

public struct GameView: View {
    public init() {}

    public var body: some View {
        SpriteKitContainer()
            .ignoresSafeArea()
    }
}
#Preview("GameView") {
    GameView()
}
