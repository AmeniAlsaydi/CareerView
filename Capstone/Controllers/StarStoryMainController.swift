//
//  StarStoryMainController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StarStoryMainController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var starSituations: [StarSituation]?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadStarSituations()
    }
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        navigationItem.title = "STAR Stories: \(starSituations?.count ?? 0)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(segueToAddStarStoryViewController(_:)))
    }
    
    private func loadStarSituations() {
        DatabaseService.shared.fetchStarSituations { [weak self] (results) in
            switch results {
            case .failure(let error):
                self?.showAlert(title: "Failed to load STAR Situations", message: error.localizedDescription)
            case .success(let starSituationsData):
                print("Star situation load successful")
                self?.starSituations = starSituationsData
            }
        }
    }
    @objc private func segueToAddStarStoryViewController(_ sender: UIBarButtonItem) {
        let destinationViewController = StarStoryEntryController(nibName: "StarStoryEntryXib", bundle: nil)
        show(destinationViewController, sender: nil)
    }
}
//MARK:- Extensions on view controller
extension StarStoryMainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarStiuationCell else {
            fatalError("Failed to dequeue starSituationCell")
        }
        return cell
    }
    
    
}
extension StarStoryMainController: UICollectionViewDelegate {
    
}
extension StarStoryMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = view.frame.width
        let maxHeight = view.frame.height
        let adjustedWidth = CGFloat(maxWidth * 0.95)
        let adjustedHeight = CGFloat(maxHeight / 4)
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
}
