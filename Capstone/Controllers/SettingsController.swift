//
//  SettingsController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Settings {
    let tabs: String
    let images: UIImage
    let viewController: UIViewController
    
    
    
    static func loadSettings() -> [Settings] {
        return [
            Settings(tabs: "Account", images: UIImage(systemName: "person.fill")!, viewController: AccountViewController(nibName: "AccountViewControllerXib", bundle: nil)),
            Settings(tabs: "Settings", images: UIImage(systemName: "gear")!, viewController: SettingsViewController(nibName: "SettingsViewControllerXib", bundle: nil)),
//            Settings(tabs: "Notifications", images: UIImage(systemName: "message")!),
            Settings(tabs: "About this app", images: UIImage(systemName: "questionmark.circle")!, viewController: AboutThisAppViewController(nibName: "AboutThisAppViewControllerXib", bundle: nil)),
            Settings(tabs: "FAQ", images: UIImage(systemName: "questionmark.circle.fill")!, viewController: FAQViewController(nibName: "FAQViewControllerXib", bundle: nil)),
            Settings(tabs: "Contact Us", images: UIImage(systemName: "phone.fill")!, viewController: ContactUsViewController(nibName: "ContactUsViewControllerXib", bundle: nil))
        ]
    }
}

class SettingsController: UIViewController {
    
    @IBOutlet weak var starSituationInputToggle: UISwitch!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var appLabel: UILabel!
    
    private var allSettings = [Settings]()
    
    private var appName = ApplicationInfo.getAppName()
    private var appVersion = ApplicationInfo.getVersionBuildNumber()
    
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
        configureTableView()
        allSettings = Settings.loadSettings()
        navigationItem.title = "Profile"
        appLabel.text = "\(appName) \(appVersion)"
        navigationController?.navigationBar.prefersLargeTitles = true 
        
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
    
    private func configureTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.isScrollEnabled = false
        settingsTableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        settingsTableView.tintColor = .systemPurple
    }
    
}

extension SettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingCell else {
            fatalError()
        }
        let aSetting = allSettings[indexPath.row]
        cell.configureCell(setting: aSetting)
        return cell
    }
    
    
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = allSettings[indexPath.row].viewController
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
