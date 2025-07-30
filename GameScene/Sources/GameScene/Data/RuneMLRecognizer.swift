//
//  RuneMLRecognizer.swift
//  GameScene
//
//  Created by ChatGPT on 30.07.2025.
//

import CoreML
import CoreGraphics

public final class RuneMLRecognizer {
    private let model: RuneModel

    public init() {
        self.model = try! RuneModel(configuration: .init())
    }

    public func recognize(from input: [CGPoint]) -> RuneType? {
        let normalized = normalize(input, count: 32)

        guard let inputArray = try? MLMultiArray(shape: [1, 32, 2], dataType: .float32) else {
            return nil
        }

        for (i, point) in normalized.enumerated() {
            inputArray[[0, NSNumber(value: i), 0]] = NSNumber(value: Float(point.x))
            inputArray[[0, NSNumber(value: i), 1]] = NSNumber(value: Float(point.y))
        }

        guard let output = try? model.prediction(input_1: inputArray) else {
            return nil
        }

        return RuneType(rawValue: output.classLabel)
    }

    // 📐 Обрезает или дублирует точки до нужного количества
    private func normalize(_ input: [CGPoint], count: Int) -> [CGPoint] {
        var result = input
        if result.count > count {
            let step = Double(result.count) / Double(count)
            result = (0..<count).map { result[Int(Double($0) * step)] }
        } else if result.count < count {
            result += Array(repeating: result.last ?? .zero, count: count - result.count)
        }
        return result
    }
}

