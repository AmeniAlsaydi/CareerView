//
//  StarStoryMainController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol StarStoryMainControllerDelegate {
    func starStoryMainViewControllerDismissed(starSituations: [String])
}

class StarStoryMainController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    public var filterByJob = false
    public var userJob: UserJob?
    public var isAddingToAnswer = false
    public var isAddingToUserJob = false
    public var selectedSTARStory: StarSituation?
    public var selectedSTARStories = [StarSituation]()
    public var starSituationIDs = [String]()
    public var answerId: String?
    public var question: String?
    private var starSituations = [StarSituation]() {
        didSet {
            if filterByJob {
                guard let starSituationID = userJob?.starSituationIDs else { return }
                starSituations = starSituations.filter { starSituationID.contains($0.id) }
            }
            collectionView.reloadData()
        }
    }
    
    var delegate: StarStoryMainControllerDelegate?
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        loadStarSituations()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadStarSituations()
    }
    //MARK:- Private funcs
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
        collectionView.backgroundColor = AppColors.complimentaryBackgroundColor
        
        if let flowLayout = flowLayout,
           let collectionView = collectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
        
    }
    private func configureView() {
        if isAddingToAnswer {
            navigationItem.title = "Add a STAR Story to your answer"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.checkmarkIcon, style: .plain, target: self, action: #selector(addStarStoryToAnswer(_:)))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.xmarkIcon, style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
        } else if isAddingToUserJob {
            navigationItem.title = "Add a STAR Story to your Job"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.checkmarkIcon, style: .plain, target: self, action: #selector(addStarStoriesToUserJob(_:)))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.xmarkIcon, style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
        } else {
            navigationItem.title = "STAR Stories"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.plusIcon, style: .plain, target: self, action: #selector(segueToAddStarStoryViewController(_:)))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.infoIcon, style: .plain, target: self, action: #selector(segueToSTARStoryInfoVC(_:)))
            AppButtonIcons.buttons.navBarBackButtonItem(navigationItem: navigationItem)
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
                    self?.starSituations = starSituationsData
                }
            }
        }
    }
    @objc private func segueToSTARStoryInfoVC(_ sender: UIBarButtonItem) {
        let starStoryInfoVC = InterviewAnswerSuggestionViewController(nibName: "InterviewAnswerSuggestionXib", bundle: nil)
        starStoryInfoVC.comingFromSTARSVC = true
        present(starStoryInfoVC, animated: true)
    }
    @objc private func segueToAddStarStoryViewController(_ sender: UIBarButtonItem) {
        let destinationViewController = StarStoryEntryController(nibName: "StarStoryEntryXib", bundle: nil)
        show(destinationViewController, sender: nil)
    }
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @objc private func addStarStoriesToUserJob(_ sender: UIBarButtonItem) {
        let starSituationsToSendBack = starSituationIDs
        delegate?.starStoryMainViewControllerDismissed(starSituations: starSituationsToSendBack)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarSituationCell else {
            fatalError("Failed to dequeue starSituationCell")
        }
        let starSituation = starSituations[indexPath.row]
        
        cell.configureCell(starSituation: starSituation)
        
        if starSituationIDs.contains(starSituation.id) {
            cell.starSituationIsSelected = true
            cell.backgroundColor = .red
        }
        
        if isAddingToAnswer || isAddingToUserJob {
            cell.editButton.isHidden = true
        } else {
            cell.editButton.isHidden = false
        }
        
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAddingToUserJob {
            let starStory = starSituations[indexPath.row]
            guard let cell = collectionView.cellForItem(at: indexPath) as? StarSituationCell else { return }
            
            cell.starSituationIsSelected.toggle()
            
            if cell.starSituationIsSelected {
                cell.backgroundColor = AppColors.primaryPurpleColor
                cell.situationLabel.textColor = AppColors.whiteTextColor
                cell.layer.borderWidth = 2
                cell.layer.borderColor = AppColors.whiteTextColor.cgColor
                starSituationIDs.append(starStory.id)
            } else if cell.starSituationIsSelected == false {
                guard let indexPathForStarStorySelected = starSituationIDs.firstIndex(where: {$0 == starStory.id }) else {
                    print("No stary story index Path was found")
                    return }
                cell.backgroundColor = .systemBackground
                starSituationIDs.remove(at: indexPathForStarStorySelected)
            }
            
        } else if isAddingToAnswer {
            let starStory = starSituations[indexPath.row]
            guard let cell = collectionView.cellForItem(at: indexPath) as? StarSituationCell else { return }
            cell.starSituationIsSelected.toggle()
            if cell.starSituationIsSelected {
                cell.backgroundColor = AppColors.primaryPurpleColor
                cell.situationLabel.textColor = AppColors.whiteTextColor
                cell.layer.borderWidth = 2
                cell.layer.borderColor = AppColors.whiteTextColor.cgColor
            } else {
                cell.backgroundColor = AppColors.systemBackgroundColor
            }
            selectedSTARStory = starStory
        }
    }
    
}

extension StarStoryMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = view.frame.width
        let maxHeight = view.frame.height
        let adjustedWidth = CGFloat(maxWidth * 0.9)
        let adjustedHeight = CGFloat(maxHeight / 4)
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
}
//MARK:- StarSituationCell Delegate
extension StarStoryMainController: StarSituationCellDelegate {
    
    func editStarSituationPressed(starSituation: StarSituation, starSituationCell: StarSituationCell) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertaction in self.deleteStarSituation(starSituation: starSituation, starSituationCell: starSituationCell) }
        let editAction = UIAlertAction(title: "Edit", style: .default) {
            alertAction in self.editStarSituation(starSituation: starSituation, starSituationCell: starSituationCell)
        }
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func editStarSituation(starSituation: StarSituation, starSituationCell: StarSituationCell) {
        let destinationViewController = StarStoryEntryController(nibName: "StarStoryEntryXib", bundle: nil)
        destinationViewController.starSituation = starSituation
        destinationViewController.isEditingStarSituation = true
        navigationController?.pushViewController(destinationViewController, animated: true)
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
