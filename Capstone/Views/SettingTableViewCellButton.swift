//
//  SettingTableViewCellButton.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol defaultLaunchScreenButtonDelegate: AnyObject {
    func changeDefaultLaunchScreenButtonPressed()
}

//struct LaunchScreen {
//    let title: String
//    static func getLaunchScreens() -> [LaunchScreen] {
//        return [LaunchScreen(title: "Job History"),
//                LaunchScreen(title: "STAR Stories"),
//                LaunchScreen(title: "Interview Questions"),
//                LaunchScreen(title: "Application Tracker")]
//    }
//    public enum launchScreens: String {
//        case jobHistory = "Job History"
//        case starStories = "STAR Stories"
//        case interviewQuestions = "Interview Questions"
//        case applicationTracker = "Application Tracker"
//    }
//}
class SettingTableViewCellButton: UITableViewCell {
    
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var defaultButton: UIButton!
    
    weak var delegate: defaultLaunchScreenButtonDelegate?
    
    private var defaultLaunchScreenPreference: DefaultLaunchScreen?
    
    public func configureCell(setting: SettingsCell) {
        loadDefaultLaunchScreen()
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
