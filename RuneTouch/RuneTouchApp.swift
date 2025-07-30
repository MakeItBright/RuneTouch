//
//  RuneTouchApp.swift
//  RuneTouch
//
//  Created by Juri Breslauer on 7/30/25.
//

import SwiftUI
import SettingsScreenService
import GameScene

@main
struct RuneTouchApp: App {
    enum Screen {
        case splash
        case main
        case settings
        case game
    }

    @State private var screen: Screen = .splash
    let settingsStorage = SettingsStorage()

    var body: some Scene {
        WindowGroup {
            switch screen {

            case .splash:
                SplashScreenView {
                    screen = .main
                }

            case .main:
                VStack(spacing: 20) {
                    Text("RuneTouch")
                        .font(.largeTitle)

                    Button("🎮 Играть") {
                        screen = .game
                    }

                    Button("⚙️ Настройки") {
                        screen = .settings
                    }
                }

            case .settings:
                SettingsScreenView(storage: settingsStorage) {
                    screen = .main
                }

            case .game:
                GameView {
                    screen = .main
                }
            }
        }
    }
}
