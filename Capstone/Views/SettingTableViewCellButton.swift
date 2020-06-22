//
//  SettingTableViewCellButton.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SettingTableViewCellButton: UITableViewCell {
    
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    
    private var defaultLaunchScreen: String?
    
    public func configureCell(setting: SettingsCell) {
        loadDefaultLaunchScreen()
        defaultLabel.text = ("Launch Screen: \(defaultLaunchScreen ?? "Not set")")
        
    }
    private func loadDefaultLaunchScreen() {
        if let defaultLaunchScreenPreference = UserPreference.shared.getDefaultLaunchScreen() {
            switch defaultLaunchScreenPreference.rawValue {
            case 1:
                defaultLaunchScreen = "Job History"
            case 2:
                defaultLaunchScreen = "STAR Stories"
            case 3:
                defaultLaunchScreen = "Interview Questions"
            case 4:
                defaultLaunchScreen = "Application Tracker"
            default:
                defaultLaunchScreen = "Job History"
            }
        }
    }
}
