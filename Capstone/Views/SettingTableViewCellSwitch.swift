//
//  SettingTableViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SettingTableViewCellSwitch: UITableViewCell {
    
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    
    private var showUserStarSituationInputOption: ShowUserStarInputOption? {
        didSet {
            if showUserStarSituationInputOption?.rawValue == ShowUserStarInputOption.off.rawValue {
                settingSwitch.isOn = false
            } else {
                settingSwitch.isOn = true
            }
            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption ?? ShowUserStarInputOption.on)
        }
    }
    
    public func configureCell(setting: SettingsCell) {
        settingSwitch.onTintColor = #colorLiteral(red: 0.557056725, green: 0.1121184751, blue: 1, alpha: 1)
        settingLabel.text = setting.title
        if setting.title == SettingsCell.settings.showUserSTARStoryOption.rawValue {
            loadUserPreferenceSTARStoryOption()
            settingSwitch.addTarget(self, action: #selector(starSituationInputOptionToggled(_:)), for: .touchUpInside)
        }
    }
    private func loadUserPreferenceSTARStoryOption() {
        if let showStarSituationInputOption = UserPreference.shared.getPreferenceShowInputOption() {
            showUserStarSituationInputOption = showStarSituationInputOption
        }
    }
    @objc func starSituationInputOptionToggled(_ sender: UISwitch) {
        if sender.isOn {
            showUserStarSituationInputOption = ShowUserStarInputOption.on
        } else {
            showUserStarSituationInputOption = ShowUserStarInputOption.off
        }
    }
}
