//
//  RuneRecognizer.swift
//  GameScene
//
//  Created by Juri Breslauer on 7/30/25.
//
//  Продвинутое распознавание рун по направлению и форме

import CoreGraphics
public final class RuneRecognizer {
    public init() {}

    public func recognize(from input: [CGPoint]) -> RuneType? {
        guard input.count >= 3 else { return nil }

        let start = input.first!
        let end = input.last!
        let dx = end.x - start.x
        let dy = end.y - start.y
        let distance = hypot(dx, dy)

        // 🔥 fire — почти вертикальный свайп (с допуском)
        if distance > 80,
           angleBetween(start: start, end: end).isInRange(60...120),
           isMostlyVertical(input),
           !hasSharpAngle(in: input)
        {
            return .fire
        }

        // ❄️ ice — горизонтальный свайп
        if distance > 80,
           angleBetween(start: start, end: end).isInRange(-20...20),
           isMostlyHorizontal(input) {
            return .ice
        }

        // ⚡️ lightning — зигзаг: ≥3 смены по Y, ≥2 по X
        let verticalZigzags = countDirectionChanges(in: input, axis: .y, threshold: 20)
        let horizontalZigzags = countDirectionChanges(in: input, axis: .x, threshold: 20)
        if verticalZigzags >= 3 && horizontalZigzags >= 2 && distance > 100 {
            return .lightning
        }

        return nil
    }
    
    private func isMostlyVertical(_ points: [CGPoint]) -> Bool {
        guard points.count >= 2 else { return false }

        var totalDX: CGFloat = 0
        var totalDY: CGFloat = 0

        for i in 1..<points.count {
            totalDX += abs(points[i].x - points[i - 1].x)
            totalDY += abs(points[i].y - points[i - 1].y)
        }

        return totalDY > totalDX * 2
    }

    private func isMostlyHorizontal(_ points: [CGPoint]) -> Bool {
        guard points.count >= 2 else { return false }

        var totalDX: CGFloat = 0
        var totalDY: CGFloat = 0

        for i in 1..<points.count {
            totalDX += abs(points[i].x - points[i - 1].x)
            totalDY += abs(points[i].y - points[i - 1].y)
        }

        return totalDX > totalDY * 2
    }

    private enum Axis { case x, y }

    private func countDirectionChanges(in points: [CGPoint], axis: Axis, threshold: CGFloat) -> Int {
        guard points.count >= 3 else { return 0 }

        var changes = 0
        var lastDelta: CGFloat = 0

        for i in 1..<points.count {
            let delta: CGFloat
            switch axis {
            case .x: delta = points[i].x - points[i - 1].x
            case .y: delta = points[i].y - points[i - 1].y
            }

            if abs(delta) < threshold { continue }

            if lastDelta != 0 && (delta.sign != lastDelta.sign) {
                changes += 1
            }

            lastDelta = delta
        }

        return changes
    }
    
    private func angleBetween(start: CGPoint, end: CGPoint) -> CGFloat {
        let dx = end.x - start.x
        let dy = end.y - start.y
        return abs(atan2(dy, dx) * 180 / .pi)
    }
    
    private func hasSharpAngle(in points: [CGPoint], threshold: CGFloat = 45) -> Bool {
        guard points.count >= 3 else { return false }

        for i in 1..<points.count - 1 {
            let p0 = points[i - 1]
            let p1 = points[i]
            let p2 = points[i + 1]

            let angle = angleBetweenThreePoints(p0, p1, p2)
            if angle < threshold {
                return true // острый угол найден
            }
        }

        return false
    }

    private func angleBetweenThreePoints(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let a = CGPoint(x: p0.x - p1.x, y: p0.y - p1.y)
        let b = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)

        let dot = a.x * b.x + a.y * b.y
        let magA = hypot(a.x, a.y)
        let magB = hypot(b.x, b.y)

        guard magA > 0, magB > 0 else { return 180 }

        let cosTheta = dot / (magA * magB)
        return acos(max(-1, min(1, cosTheta))) * 180 / .pi
    }

}

private extension CGFloat {
    func isInRange(_ range: ClosedRange<CGFloat>) -> Bool {
        return range.contains(self)
    }
}
