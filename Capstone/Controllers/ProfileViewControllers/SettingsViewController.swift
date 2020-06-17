//
//  SettingsViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

struct SettingsCell {
    let title: String
    
    static func loadSettingsCells() -> [SettingsCell] {
        return [
            SettingsCell(title: settings.showUserSTARStoryOption.rawValue)
        ]
    }
    public enum settings: String {
        case showUserSTARStoryOption = "Show User STAR Story Option"
    }
}

class SettingsViewController: UIViewController {
    
    private var settings = [SettingsCell]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    private func loadSettings() {
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        settings = SettingsCell.loadSettingsCells()
    }

}
//MARK:- Extensions
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingTableViewCell else {
            fatalError("Failed to dequeue Settings Cell")
        }
        cell.configureCell(setting: settings[indexPath.row])
        return cell
    }

}

extension SettingsViewController: UITableViewDelegate {
    
}
