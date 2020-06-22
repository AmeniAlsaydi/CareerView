//
//  SettingsViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
// Conflict amirite?
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

class SettingsViewController: UIViewController {
    
    private var settings = [SettingsCell]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        loadSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    private func configureNavBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        tableView.register(UINib(nibName: "SettingTableViewCellButton", bundle: nil), forCellReuseIdentifier: "settingsCellButton")
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInsetAdjustmentBehavior = .never
        navigationItem.largeTitleDisplayMode = .automatic
        tableView.scrollsToTop = true
    }
    private func loadSettings() {
        settings = SettingsCell.loadSettingsCells()
    }

}
//MARK:- Extensions
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        switch setting {
        case setting where setting.title == SettingsCell.settingsEnum.showUserSTARStoryOption.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingTableViewCellSwitch else {
                fatalError("Failed to dequeue Settings switch Cell")
            }
            cell.configureCell(setting: setting)
            return cell
        case setting where setting.title == SettingsCell.settingsEnum.defaultLaunchScreen.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCellButton", for: indexPath) as? SettingTableViewCellButton else {
                fatalError("Failed to dequeue settings button cell")
            }
            cell.configureCell(setting: setting)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingTableViewCellSwitch else {
                fatalError("Failed to dequeue Settings switch Cell")
            }
            cell.configureCell(setting: setting)
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}
