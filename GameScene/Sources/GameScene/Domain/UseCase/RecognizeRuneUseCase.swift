//
//  RecognizeRuneUseCase.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//

import CoreGraphics

public final class RecognizeRuneUseCase {
    private let recognizer: RuneRecognizer

    public init(recognizer: RuneRecognizer) {
        self.recognizer = recognizer
    }

    public func execute(inputPoints: [CGPoint]) -> RuneType? {
        recognizer.recognize(from: inputPoints)
    }
}
