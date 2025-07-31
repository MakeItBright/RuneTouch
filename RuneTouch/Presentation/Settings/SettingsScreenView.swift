//
//  SettingsScreenView.swift
//  SettingsScreenService
//
//  Created by Juri Breslauer on 7/30/25.
//

import SwiftUI

public struct SettingsScreenView: View {
    @ObservedObject var storage: SettingsStorage
    let onBack: () -> Void

    public init(storage: SettingsStorage = .init(), onBack: @escaping () -> Void) {
        self.storage = storage
        self.onBack = onBack
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Настройки")) {
                    Toggle("Звук", isOn: Binding(
                        get: { storage.settings.isSoundOn },
                        set: { _ in storage.toggleSound() }
                    ))
                    Toggle("Музыка", isOn: Binding(
                        get: { storage.settings.isMusicOn },
                        set: { _ in storage.toggleMusic() }
                    ))
                }

                Button("← Назад") {
                    onBack()
                }
            }
            .navigationTitle("⚙️ Настройки")
        }
    }
}
