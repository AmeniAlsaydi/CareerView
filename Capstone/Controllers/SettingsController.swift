//
//  SettingsController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var starSituationInputToggle: UISwitch!
    
    private var showUserStarSituationInputOption = ShowUserStarInputOption.on {
        didSet {
            if showUserStarSituationInputOption.rawValue == ShowUserStarInputOption.off.rawValue {
                starSituationInputToggle.isOn = false
            } else {
                starSituationInputToggle.isOn = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    private func loadSettings() {
        if let showStarSituationInputOption = UserPreference.shared.getPreferenceShowInputOption() {
            showUserStarSituationInputOption = showStarSituationInputOption
        }
        
    }
    @IBAction func starSituationInputOptionToggled(_ sender: UISwitch) {
        if sender.isOn {
            showUserStarSituationInputOption = ShowUserStarInputOption.on
            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption)
        } else {
            
            showUserStarSituationInputOption = ShowUserStarInputOption.off
            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption)
        }
        print("Star Situation Input option: \(showUserStarSituationInputOption.rawValue)")
    }
    
}
