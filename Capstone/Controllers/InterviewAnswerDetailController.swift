//
//  InterviewAnswerDetailController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewAnswerDetailController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    @IBOutlet weak var starStoriesCollectionView: UICollectionView!
    @IBOutlet weak var suggestionLabel: UILabel!
    
    public var question: InterviewQuestion?
    
    public var answers = [InterviewAnswer]() {
        didSet {
            self.answersCollectionView.reloadData()
        }
    }
    public var starStories = [StarSituation]() {
        didSet {
            self.starStoriesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureCollectionViews()
    }
    private func configureCollectionViews() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        answersCollectionView.register(UINib(nibName: "QuestionAnswerDetailCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewAnswerCell")
        
        starStoriesCollectionView.delegate = self
        starStoriesCollectionView.dataSource = self
        starStoriesCollectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
    }
    private func updateUI() {
        questionLabel.text = question?.question
        suggestionLabel.text = question?.suggestion ?? ""
    }
    private func getUserAnswers() {
        //TODO: get user answers from firebase
    }
    private func getUserSTARS() {
        //TODO: get user star stories for user job
    }
    
    @IBAction func addAnswerButtonPressed(_ sender: UIButton){
        //TODO: add view/or something related where user could add their answer into a textfield and save
    }
    @IBAction func addSTARStoryButtonPressed(_ sender: UIButton) {
        //TODO: add view/or something related where user could search and select their star situation
    }
    

}
extension InterviewAnswerDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width
        let itemHeight: CGFloat = maxsize.height * 0.20
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
extension InterviewAnswerDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == answersCollectionView {
            return answers.count
        } else if collectionView == starStoriesCollectionView {
            return starStories.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == answersCollectionView {
            guard let cell = answersCollectionView.dequeueReusableCell(withReuseIdentifier: "interviewAnswerCell", for: indexPath) as? QuestionAnswerDetailCell else {
                fatalError("could not cast to QuestionAnswerDetailCell")
            }
            
            let answer = answers[indexPath.row]
            cell.configureCell(answer: answer.answer.first ?? "")
            return cell
        } else {
            guard let cell = starStoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarStiuationCell else {
                fatalError("could not cast to StarSituationCell")
            }
            let story = starStories[indexPath.row]
            cell.configureCell(starSituation: story)
            return cell
        }
        
    }
    
    
}
