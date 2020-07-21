//
//  SettingsCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 7/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct SettingsCell: Equatable {
    let title: String

    static func loadSettingsCells() -> [SettingsCell] {
        return [
            SettingsCell(title: settingsEnum.showUserSTARStoryOption.rawValue),
            SettingsCell(title: settingsEnum.defaultLaunchScreen.rawValue)
        ]
    }
    public enum settingsEnum: String {
        case showUserSTARStoryOption = "Show User STAR Story Option"
        case defaultLaunchScreen = "Default Launch Screen"
    }
}
