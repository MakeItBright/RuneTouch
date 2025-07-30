//
//  Rune.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//

import CoreGraphics

public enum RuneType: String {
    case fire
    case ice
    case lightning
}

public struct Rune {
    public let type: RuneType
    public let points: [CGPoint]

    public init(type: RuneType, points: [CGPoint]) {
        self.type = type
        self.points = points
    }
}
