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
    
    private var starSituations = [StarSituation]() {
        didSet {
            collectionView.reloadData()
            navigationItem.title = "STAR Stories: \(starSituations.count)"
        }
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "STAR Stories: \(starSituations.count)"
        loadStarSituations()
    }
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(segueToAddStarStoryViewController(_:)))
    }
    
    private func loadStarSituations() {
        DatabaseService.shared.fetchStarSituations { [weak self] (results) in
            switch results {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to load STAR Situations", message: error.localizedDescription)
                }
            case .success(let starSituationsData):
                DispatchQueue.main.async {
                    print("Star situation load successful")
                    self?.starSituations = starSituationsData
                    self?.navigationItem.title = "STAR Stories: \(self?.starSituations.count ?? 0)"
                }
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
        return starSituations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarSituationCell else {
            fatalError("Failed to dequeue starSituationCell")
        }
        let starSituation = starSituations[indexPath.row]
        cell.configureCell(starSituation: starSituation)
        cell.delegate = self
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
//MARK:- StarSituationCell Delegate
extension StarStoryMainController: StarSituationCellDelegate {
    
    func editStarSituationPressed(starSituation: StarSituation, starSituationCell: StarSituationCell) {
        let destinationViewController = StarStoryEntryController(nibName: "StarStoryEntryXib", bundle: nil)
        destinationViewController.starSituation = starSituation
        destinationViewController.isEditingStarSituation = true
        show(destinationViewController, sender: nil)
    }
    
    func longPressOnStarSituation(starSituation: StarSituation, starSituationCell: StarSituationCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertaction in self.deleteStarSituation(starSituation: starSituation, starSituationCell: starSituationCell) }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    private func deleteStarSituation(starSituation: StarSituation, starSituationCell: StarSituationCell) {
        guard let index = starSituations.firstIndex(of: starSituation) else { return }
        DispatchQueue.main.async {
            DatabaseService.shared.removeStarSituation(situation: starSituation) { (result) in
                switch result {
                case .failure(let error):
                    self.showAlert(title: "Failed to delete STAR Situation", message: error.localizedDescription)
                case .success:
                    self.showAlert(title: "Success", message: "STAR Situation deleted")
                    self.starSituations.remove(at: index)
                }
            }
        }
    }
}
