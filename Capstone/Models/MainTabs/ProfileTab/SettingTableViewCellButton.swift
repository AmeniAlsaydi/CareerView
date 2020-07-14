//
//  SettingTableViewCellButton.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

//MARK:- Protocols
protocol defaultLaunchScreenButtonDelegate: AnyObject {
    func changeDefaultLaunchScreenButtonPressed()
}

class SettingTableViewCellButton: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    //MARK:- Variables
    weak var delegate: defaultLaunchScreenButtonDelegate?
    private var defaultLaunchScreenPreference: DefaultLaunchScreen?
    //MARK:- Functions
    public func configureCell(setting: SettingsCell) {
        loadDefaultLaunchScreen()
        defaultButton.tintColor = AppColors.secondaryPurpleColor
        defaultButton.addTarget(self, action: #selector(changeLaunchScreenButtonPressed(_:)), for: .touchUpInside)
        defaultLabel.text = ("Launch Screen: \(defaultLaunchScreenPreference?.rawValue ?? DefaultLaunchScreen.jobHistory.rawValue)")
    }
    @objc private func changeLaunchScreenButtonPressed(_ sender: UIButton) {
        delegate?.changeDefaultLaunchScreenButtonPressed()
    }
    private func loadDefaultLaunchScreen() {
        defaultLaunchScreenPreference = UserPreference.shared.getDefaultLaunchScreen()
    }
}
