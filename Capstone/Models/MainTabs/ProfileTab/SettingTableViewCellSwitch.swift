//
//  SettingTableViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SettingTableViewCellSwitch: UITableViewCell {
    //MARK:- IBOulets
    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var settingLabel: UILabel!
    //MARK:- Variables
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
    //MARK:- Functions
    public func configureCell(setting: SettingsCell) {
        settingSwitch.onTintColor = AppColors.primaryPurpleColor
        settingLabel.text = setting.title
        if setting.title == SettingsCell.settingsEnum.showUserSTARStoryOption.rawValue {
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
