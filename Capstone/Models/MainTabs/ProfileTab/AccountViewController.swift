//
//  AccountViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    //MARK:- Variables
    private var userInfo: [UserInfo.userInfoSection]? {
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        loadUserInfo()
    }
    
    //MARK:- Functions
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "BasicInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basicInfoCell")
        if let flowLayout = collectionViewLayout,
            let collectionView = collectionView {
            let w = collectionView.frame.width
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
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
//MARK:- Extensions
extension AccountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicInfoCell", for: indexPath) as? BasicInfoCollectionViewCell else {
            fatalError("Failed to dequeue BasicInfoCollectionViewCell")
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
