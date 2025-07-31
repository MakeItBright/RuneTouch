//
//  ThemeManager.swift
//  mathpuzzle
//
//  Created by Juri Breslauer on 7/23/25.
//
// Core/Theme/ThemeManager.swift
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = AppTheme.system.rawValue

    var appTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }

    var colorScheme: ColorScheme? {
        switch appTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }

    func setTheme(_ theme: AppTheme) {
        selectedTheme = theme.rawValue
    }
    
    func isDark(using systemColorScheme: ColorScheme) -> Bool {
            switch appTheme {
            case .dark:
                return true
            case .light:
                return false
            case .system:
                return systemColorScheme == .dark
            }
        }
}
