//
//  RuneTouchApp.swift
//  RuneTouch
//
//  Created by Juri Breslauer on 7/30/25.
//

import SwiftUI
import SettingsScreenService

@main
//struct RuneTouchApp: App {
//    var body: some Scene {
//        WindowGroup {
//            GameView()
//        }
//    }
//}

struct RuneTouchApp: App {
    enum Screen {
        case main
        case settings
    }

    @State private var screen: Screen = .main
    private let settingsStorage = SettingsStorage()

    var body: some Scene {
        WindowGroup {
            switch screen {
//            case .splash:
//                SplashScreenView {
//                    screen = .main
//                }
            case .main:
                VStack(spacing: 20) {
                    Text("RuneTouch")
                        .font(.largeTitle)
                    Button("⚙️ Настройки") {
                        screen = .settings
                    }
                }
            case .settings:
                SettingsScreenView(storage: settingsStorage) {
                    screen = .main
                }
            }
        }
    }
}
