//
//  SettingsController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

struct ProfileCells {
    let tabs: String
    let images: UIImage
    let viewController: UIViewController
    
    static func loadProfileCells() -> [ProfileCells] {
        return [
            ProfileCells(tabs: "Account", images: UIImage(systemName: "person.fill")!, viewController: AccountViewController(nibName: "AccountViewControllerXib", bundle: nil)),
            ProfileCells(tabs: "Settings", images: UIImage(systemName: "gear")!, viewController: SettingsViewController(nibName: "SettingsViewControllerXib", bundle: nil)),
//            Settings(tabs: "Notifications", images: UIImage(systemName: "message")!),
            ProfileCells(tabs: "About this app", images: UIImage(systemName: "questionmark.circle")!, viewController: AboutThisAppViewController(nibName: "AboutThisAppViewControllerXib", bundle: nil)),
            ProfileCells(tabs: "FAQ", images: UIImage(systemName: "questionmark.circle.fill")!, viewController: FAQViewController(nibName: "FAQViewControllerXib", bundle: nil)),
            ProfileCells(tabs: "Contact Us", images: UIImage(systemName: "phone.fill")!, viewController: ContactUsViewController(nibName: "ContactUsViewControllerXib", bundle: nil))
        ]
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var appLabel: UILabel!
    
    private var allSettings = [ProfileCells]()
    private var appName = ApplicationInfo.getAppName()
    private var appVersion = ApplicationInfo.getVersionBuildNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        configureTableView()
        allSettings = ProfileCells.loadProfileCells()
        navigationItem.title = "Profile"
        appLabel.text = "\(appName) \(appVersion)"
        navigationController?.navigationBar.prefersLargeTitles = true 
        
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
        settingsTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        settingsTableView.tintColor = .systemPurple
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSettings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileCell else {
            fatalError()
        }
        let aSetting = allSettings[indexPath.row]
        cell.configureCell(setting: aSetting)
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = allSettings[indexPath.row].viewController
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
