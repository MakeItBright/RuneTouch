//
//  SettingsStorage.swift
//  SettingsScreenService
//
//  Created by Juri Breslauer on 7/30/25.
//

import Foundation

public final class SettingsStorage: ObservableObject {
    @Published public private(set) var settings: Settings

    private let key = "SettingsData"

    public init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = Settings()
        }
    }

    public func update(_ newSettings: Settings) {
        settings = newSettings
        if let data = try? JSONEncoder().encode(newSettings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    public func toggleSound() {
        var new = settings
        new.isSoundOn.toggle()
        update(new)
    }

    public func toggleMusic() {
        var new = settings
        new.isMusicOn.toggle()
        update(new)
    }
}
