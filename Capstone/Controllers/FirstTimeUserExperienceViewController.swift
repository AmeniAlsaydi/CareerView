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
        configureView()
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
    private func configureView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ScreenshotCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "screenshotCell")
        
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = screenshots.count
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

    @IBAction func skipForNowButtonPressed(_ sender: UIButton) {
        print("skip for now pressed")
        UIViewController.showMainAppView()
    }
}

extension FirstTimeUserExperienceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = collectionView.frame.width
        let itemWidth: CGFloat = maxWidth * 0.95
        let maxHeight: CGFloat = collectionView.frame.height
        let itemHeight: CGFloat = maxHeight * 0.95
        return CGSize(width: maxWidth, height: maxHeight)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
}
extension FirstTimeUserExperienceViewController: UICollectionViewDelegate {
    
}
extension FirstTimeUserExperienceViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return screenshots.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
        IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotCell", for: indexPath) as? ScreenshotCollectionViewCell else {
            fatalError("failed to dequeue screenshot cell")
        }
        switch indexPath.section {
        case 0:
            let currentScreenshot = screenshots[0]
            cell.configureCell(screenshot: currentScreenshot)
            return cell
        case 1:
            let currentScreenshot = screenshots[1]
            cell.configureCell(screenshot: currentScreenshot)
            return cell
        case 2:
            let currentScreenshot = screenshots[2]
            cell.configureCell(screenshot: currentScreenshot)
            return cell
        case 3:
            let currentScreenshot = screenshots[3]
            cell.configureCell(screenshot: currentScreenshot)
            return cell
        default:
            let currentScreenshot = screenshots[0]
            cell.configureCell(screenshot: currentScreenshot)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.section
    }
}
