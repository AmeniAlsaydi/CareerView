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
    
    var toolbar = UIToolbar()
    var defaultLaunchScreenPicker = UIPickerView()
    
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
            cell.delegate = self
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

extension SettingsViewController: defaultLaunchScreenButtonDelegate {
    func changeDefaultLaunchScreenButtonPressed() {
        defaultLaunchScreenPicker = UIPickerView.init()
        defaultLaunchScreenPicker.delegate = self
        defaultLaunchScreenPicker.autoresizingMask = .flexibleWidth
        defaultLaunchScreenPicker.contentMode = .center
        defaultLaunchScreenPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        defaultLaunchScreenPicker.backgroundColor = .green
        self.view.addSubview(defaultLaunchScreenPicker)
        
        toolbar.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50)
        toolbar.barStyle = .black
        toolbar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolbar)
        
    }
    @objc func onDoneButtonTapped() {
        toolbar.removeFromSuperview()
        defaultLaunchScreenPicker.removeFromSuperview()
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Title goes here"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print([row])
    }
    
}
