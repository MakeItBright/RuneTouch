//
//  Settimgs.swift
//  SettingsScreenService
//
//  Created by Juri Breslauer on 7/30/25.
//

import Foundation

public struct Settings: Codable {
    public var isSoundOn: Bool
    public var isMusicOn: Bool

    public init(isSoundOn: Bool = true, isMusicOn: Bool = true) {
        self.isSoundOn = isSoundOn
        self.isMusicOn = isMusicOn
    }
}
