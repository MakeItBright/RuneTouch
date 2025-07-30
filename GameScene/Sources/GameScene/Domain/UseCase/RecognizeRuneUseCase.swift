//
//  RecognizeRuneUseCase.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//


import CoreGraphics

public final class RecognizeRuneUseCase {
    private let mlRecognizer: RuneMLRecognizer
    private let fallbackRecognizer: RuneRecognizer

    public init(
        mlRecognizer: RuneMLRecognizer = RuneMLRecognizer(),
        fallbackRecognizer: RuneRecognizer = RuneRecognizer()
    ) {
        self.mlRecognizer = mlRecognizer
        self.fallbackRecognizer = fallbackRecognizer
    }

    public func execute(inputPoints: [CGPoint]) -> RuneType? {
        // 1. Сначала пробуем ML-модель
        if let mlResult = mlRecognizer.recognize(from: inputPoints) {
            return mlResult
        }

        // 2. Если не получилось — используем эвристику
        return fallbackRecognizer.recognize(from: inputPoints)
    }
}
