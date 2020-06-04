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
    
    public var answers = [AnsweredQuestion]() {
        didSet {
            answersCollectionView.reloadData()
            if answers.isEmpty {
                answersCollectionView.backgroundView = EmptyView.init(title: "No Answers", message: "Add your answers by pressing the add button", imageName: "plus.circle")
            } else {
                answersCollectionView.reloadData()
                answersCollectionView.backgroundView = nil
            }
        }
    }
    private var newAnswers = [String]()
    private var newStarStorieIDs = [String]()
    
    public var starStories = [StarSituation]() {
        didSet {
            starStoriesCollectionView.reloadData()
            if starStories.isEmpty {
                starStoriesCollectionView.backgroundView = EmptyView.init(title: "No STAR Stories", message: "Add your story by pressing the add button", imageName: "plus.circle")
            } else {
                answersCollectionView.reloadData()
                answersCollectionView.backgroundView = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureCollectionViews()
        getUserSTARS()
        getUserAnswers()
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
        guard let question = question else {return}
        DatabaseService.shared.fetchAnsweredQuestions(questionString: question.question) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to fetch user answers error: \(error.localizedDescription)")
            case .success(let answers):
                DispatchQueue.main.async {
                    self?.answers = answers
                }
            }
        }
    }
    private func getUserSTARS() {
        DatabaseService.shared.fetchStarSituations { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to fetch user STAR stories error: \(error.localizedDescription)")
            case .success(let stars):
                DispatchQueue.main.async {
                    self?.starStories = stars.filter {$0.interviewQuestionsIDs.contains(self?.question?.id ?? "")}
                }
            }
        }
    }
    
    @IBAction func addAnswerButtonPressed(_ sender: UIButton){
        //TODO: add view/or something related where user could add their answer into a textfield and save
        let answerQuestionXib = "AnswerQuestionChildViewXib"
        let child = ChildViewController(nibName: answerQuestionXib, bundle: nil)
        self.addChild(child, frame: UIScreen.main.bounds)
        child.delegate = self
        //need keyboard handeling :(
    }
    @IBAction func addSTARStoryButtonPressed(_ sender: UIButton) {
        //TODO: add view/or something related where user could search and select their star situation
    }
    
}
extension InterviewAnswerDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width * 0.8
        return CGSize(width: itemWidth, height: itemWidth * 0.5)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
            cell.configureCell(answer: answer.answers.first ?? "")
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
extension InterviewAnswerDetailController {
    //TODO: Move this to its own file for other vc's needing a child view controller
    
    func addChild(_ childController: UIViewController, frame: CGRect? = nil) {
        //add child view controller
        addChild(childController)
        
        //set the size of the child view controller's frame to half the parent view controller's height
        //frame = UIScreen.main.bounds
        if let frame = frame {
            let height: CGFloat = frame.height * 0.5
            let width: CGFloat = frame.width
            let x: CGFloat = frame.minX
            let y: CGFloat = frame.midY
            childController.view.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        //add the childcontroller's view as the parent view controller's subview
        view.addSubview(childController.view)
        //pass child to parent
        childController.didMove(toParent: self)
    }
    func removeChild(childController: UIViewController) {
        //willMove assigns next location for this child view controller. since we dont need it elsewhere, we assign it to nil
        willMove(toParent: nil)
        
        //remove the child view controller's view from parent's view
        childController.view.removeFromSuperview()
        
        //remove child view controller from parent view controller
        removeFromParent()
    }
}
extension InterviewAnswerDetailController: ChildViewControllerActions {
    func userPressedCancel(childViewController: ChildViewController) {
        removeChild(childController: childViewController)
        //dismiss(animated: true)
    }
    
    func userEnteredAnswer(childViewController: ChildViewController, answer: String) {
        //1. append answer to newAnswers array
        //2. check if AnsweredQuestion has answers or star stories for this question
            //a. if it does, use update function
            //b. if it doesn't, use create function -> repeat for star story child
        newAnswers.append(answer)
        
        if answers.count < 1 && starStories.count < 0 {
            let newAnswer = AnsweredQuestion(id: UUID().uuidString, question: question?.question ?? "could not pass question", answers: newAnswers, starSituationIDs: newStarStorieIDs)
            DatabaseService.shared.addToAnsweredQuestions(answeredQuestion: newAnswer) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Unable to add answer at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Answer Submitted!", message: "")
                    }
                    self?.removeChild(childController: childViewController)
                }
            }
            
        } else {
            //TODO: Update AnsweredQuestion
        }
        
    }
    
    
}
