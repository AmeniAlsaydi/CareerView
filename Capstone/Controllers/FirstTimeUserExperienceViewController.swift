//
//  FirstTimeUserExperienceViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FirstTimeUserExperienceViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    private var screenshots = ["screenshot1", "screenshot2", "screenshot3", "screenshot4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ScreenshotCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "screenshotCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateUserFirstTimeLogin()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func updateUserFirstTimeLogin() {
        DatabaseService.shared.updateUserFirstTimeLogin(firstTimeLogin: false) { (result) in
            switch result {
            case.failure(let error):
                print("error updating user first time login: \(error.localizedDescription)")
            case .success:
                print("User first time login update successfully")
            }
        }
    }
    private func updatePageControlPage(screenshot: String) {

    }
    @IBAction func skipForNowButtonPressed(_ sender: UIButton) {
        print("skip for now pressed")
        UIViewController.showMainAppView()
    }
}

extension FirstTimeUserExperienceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.95
        let maxHeight: CGFloat = UIScreen.main.bounds.size.height
        let itemHeight: CGFloat = maxHeight * 0.95
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
extension FirstTimeUserExperienceViewController: UICollectionViewDelegate {
    
}
extension FirstTimeUserExperienceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotCell", for: indexPath) as? ScreenshotCollectionViewCell else {
            fatalError("failed to dequeue screenshot cell")
        }
        let currentScreenshot = screenshots[indexPath.row]
        cell.configureCell(screenshot: currentScreenshot)
        return cell
    }
    
    
}
