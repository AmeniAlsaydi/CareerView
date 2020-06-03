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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ScreenshotCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "screenshotCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateUserFirstTimeLogin()
        
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
        cell.configureCell(index: indexPath.row)
        return cell
    }
    
    
}
