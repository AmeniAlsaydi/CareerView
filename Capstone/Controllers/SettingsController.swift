//
//  SettingsController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsController: UIViewController {
    
    @IBOutlet weak var starSituationInputToggle: UISwitch!
    
    private var showUserStarSituationInputOption: ShowUserStarInputOption? {
        didSet {
            if showUserStarSituationInputOption?.rawValue == ShowUserStarInputOption.off.rawValue {
                starSituationInputToggle.isOn = false
            } else {
                starSituationInputToggle.isOn = true
            }
            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption ?? ShowUserStarInputOption.on)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadSettings()
    }
    private func loadSettings() {
        if let showStarSituationInputOption = UserPreference.shared.getPreferenceShowInputOption() {
            showUserStarSituationInputOption = showStarSituationInputOption
            print("show starSituation option: \(showStarSituationInputOption.rawValue)")
        }
        
    }
    @IBAction func starSituationInputOptionToggled(_ sender: UISwitch) {
        if sender.isOn {
            showUserStarSituationInputOption = ShowUserStarInputOption.on
//            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption)
        } else {
            showUserStarSituationInputOption = ShowUserStarInputOption.off
//            UserPreference.shared.updatePreferenceShowUserInputOption(with: showUserStarSituationInputOption)
        }
        print("Star Situation Input option: \(String(describing: showUserStarSituationInputOption?.rawValue))")
    }
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
        try? FirebaseAuth.Auth.auth().signOut()
        }
        UIViewController.showLoginView()
    }
    
}
