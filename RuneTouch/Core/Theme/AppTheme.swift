//
//  AppTheme.swift
//  mathpuzzle
//
//  Created by Juri Breslauer on 7/23/25.
//
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName: LocalizedStringKey {
            switch self {
            case .system: return "systemTheme"
            case .light: return "lightTheme"
            case .dark: return "darkTheme"
            }
    }
}
