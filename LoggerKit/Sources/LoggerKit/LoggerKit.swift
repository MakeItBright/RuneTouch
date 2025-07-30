// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public enum LogLevel: String {
    case info = "ℹ️"
    case success = "✅"
    case warning = "⚠️"
    case error = "❌"
    case debug = "🛠"
}

public struct Logger {
    public static var isEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    public static func log(_ message: @autoclosure () -> String,
                           level: LogLevel = .info,
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line) {
        guard isEnabled else { return }

        let fileName = (file as NSString).lastPathComponent
        print("\(level.rawValue) [\(fileName):\(line)] \(function) → \(message())")
    }
    
    public static func ui(_ message: @autoclosure () -> String) {
        log("🖼 UI: \(message())", level: .debug)
    }

    public static func game(_ message: @autoclosure () -> String) {
        log("🎮 Game: \(message())", level: .info)
    }
    
    public static func rune(_ message: @autoclosure () -> String) {
        log("🔮 Rune: \(message())", level: .info)
    }

}
