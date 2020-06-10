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
    
    public var isAddingToAnswer = false
    public var selectedSTARStory: StarSituation?
    public var answerId: String?
    public var question: String?
    
    private var starSituations = [StarSituation]() {
        didSet {
            collectionView.reloadData()
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
        
        if isAddingToAnswer {
            navigationItem.title = "Add STAR Story to your answer"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(addStarStoryToAnswer(_:)))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
        } else {
          navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(segueToAddStarStoryViewController(_:)))
        }
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
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @objc private func addStarStoryToAnswer(_ sender: UIBarButtonItem) {
        //When a user selects a star story, save it to db function
        if selectedSTARStory == nil {
            sender.isEnabled = false
        } else {
            if let answerID = answerId {
                DatabaseService.shared.addStarSituationToAnswer(answerID: answerID, starSolutionID: selectedSTARStory?.id ?? "") { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: "Could not add STAR Story at this time error: \(error.localizedDescription)")
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.dismiss(animated: true)
                        }
                       
                    }
                }
            } else {
                let newAnswer = AnsweredQuestion(id: UUID().uuidString, question: question ?? "", answers: [], starSituationIDs: [selectedSTARStory?.id ?? ""])
                DatabaseService.shared.addToAnsweredQuestions(answeredQuestion: newAnswer) { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: "Unable to create a new answer error: \(error.localizedDescription)")
                        }
                    case .success:
                        DispatchQueue.main.async {
                            self?.dismiss(animated: true)
                        }
                    }
                }
            }
            
        }
    }
}
//MARK:- Extensions on view controller
extension StarStoryMainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starSituations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarStiuationCell else {
            fatalError("Failed to dequeue starSituationCell")
        }
        let starSituation = starSituations[indexPath.row]
        cell.configureCell(starSituation: starSituation)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddingToAnswer {
            let starStory = starSituations[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = .red //TODO: refactor! Make a button with a checkmark image to show the cell was selected
            selectedSTARStory = starStory
        }
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
