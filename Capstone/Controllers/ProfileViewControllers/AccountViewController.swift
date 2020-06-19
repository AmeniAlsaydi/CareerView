//
//  AccountViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

struct UserInfo: Equatable {
    let primaryEmail: String = userInfoSection.email.rawValue
    let jobHistoryCount: String = userInfoSection.jobHistoryCount.rawValue
    let starStoryCount: String = userInfoSection.starStoryCount.rawValue
    let jobApplicationCount: String = userInfoSection.jobApplicationCount.rawValue
    static func setupUserSectionArray() -> [userInfoSection] {
        return [userInfoSection.email, userInfoSection.jobApplicationCount, userInfoSection.jobHistoryCount, userInfoSection.starStoryCount]
    }
    public enum userInfoSection: String {
        case email = "Email Address"
        case jobHistoryCount = "Job History Count"
        case starStoryCount = "STAR Story Count"
        case jobApplicationCount = "Job Applications Being Tracked"
    }
}

class AccountViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var userInfo: [UserInfo.userInfoSection]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        loadUserInfo()
    }
    

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FAQCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "FAQCell")
        
    }
    private func configureNavBar() {
        navigationItem.title = "Account"
        let signoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(signout(_:)))
        signoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = signoutButton
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc private func signout(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            try? FirebaseAuth.Auth.auth().signOut()
        }
        UIViewController.showLoginView()
    }
    private func loadUserInfo() {
        userInfo = UserInfo.setupUserSectionArray()
    }
    
}

extension AccountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FAQCell", for: indexPath) as? FAQCollectionViewCell else {
            fatalError("Failed to dequeue FAQCollectionViewCell")
        }
        let userInfoSection = userInfo?[indexPath.row]
        cell.configureCell(faq: nil, userInfo: userInfoSection)
        return cell
    }
    
    
}
extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.frame.width
        let maxHeight = collectionView.frame.height
        return CGSize(width: maxWidth * 0.90, height: maxHeight / 5)
    }
}
