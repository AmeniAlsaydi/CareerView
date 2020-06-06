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
    @IBOutlet weak var addAnswerButton: UIButton!
    @IBOutlet weak var enterAnswerTextfield: UITextField!
    @IBOutlet weak var confirmAddAnswerButton: UIButton!
    @IBOutlet weak var cancelAnswerButton: UIButton!
    
    public var question: InterviewQuestion?
    
    public var answers = [AnsweredQuestion]() {
        didSet {
            answersCollectionView.reloadData()
            if answers.isEmpty {
                answersCollectionView.backgroundView = EmptyView.init(title: "No Answers", message: "Add your answers by pressing the add button", imageName: "plus.circle")
            } else {
                answersCollectionView.reloadData()
                answersCollectionView.backgroundView = nil
                answerStrings = answers.first?.answers ?? []
            }
        }
    }
    public var answerStrings = [String]()
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
        getUserSTARS()
        getUserAnswers()
        updateUI()
        enterAnswerTextfield.delegate = self
    }
    private func hideAddAnswerElements() {
        cancelAnswerButton.isHidden = true
        confirmAddAnswerButton.isHidden = true
        enterAnswerTextfield.isHidden = true
        enterAnswerTextfield.text = ""
        answersCollectionView.isHidden = false
        addAnswerButton.isHidden = false
    }
    private func showAddAnswerElements() {
        cancelAnswerButton.isHidden = false
        confirmAddAnswerButton.isHidden = false
        enterAnswerTextfield.isHidden = false
        answersCollectionView.isHidden = true
        addAnswerButton.isHidden = true
    }
    private func updateUI() {
        hideAddAnswerElements()
        configureNavBar()
        configureCollectionViews()
        questionLabel.text = question?.question
    }
    
    private func configureCollectionViews() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        answersCollectionView.register(UINib(nibName: "QuestionAnswerDetailCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewAnswerCell")
        
        starStoriesCollectionView.delegate = self
        starStoriesCollectionView.dataSource = self
        starStoriesCollectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
    }
    
    private func configureNavBar() {
        let suggestionButton = UIBarButtonItem(image: UIImage(systemName: "lightbulb"), style: .plain, target: self, action: #selector(suggestionButtonPressed(_:)))
        let saveQuestionButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addQuestionToSavedQuestionsButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [suggestionButton, saveQuestionButton]
    }
    
    @objc private func suggestionButtonPressed(_ sender: UIBarButtonItem) {
        let interviewQuestionSuggestionViewController = InterviewAnswerSuggestionViewController(nibName: "InterviewAnswerSuggestionXib", bundle: nil)
        interviewQuestionSuggestionViewController.interviewQuestion = question
        present(interviewQuestionSuggestionViewController, animated: true)
    }
    @objc private func addQuestionToSavedQuestionsButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: Save question to a user's collection of saved questions
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
        showAddAnswerElements()
    }
    @IBAction func cancelAddAnswerButtonPressed(_ sender: UIButton) {
        hideAddAnswerElements()
    }
    @IBAction func confirmAddAnswerButtonPressed(_ sender: UIButton) {
        guard let answer = enterAnswerTextfield.text else {
            //confirmAddAnswerButton.isEnabled = false
            return
        }
        newAnswers.append(answer)
        
        if answers.count == 0 {
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
                    self?.hideAddAnswerElements()
                }
            }
            
        } else {
            let answerId = answers.first?.id ?? ""
            DatabaseService.shared.addAnswerToAnswersArray(answerID: answerId, answerString: answer) { [weak self] (result) in
                switch result {
                case .failure(let error) :
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Unable to add answer error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Answer Submitted!", message: "")
                    }
                    self?.hideAddAnswerElements()
                }
            }
        }
        
    }
    @IBAction func addSTARStoryButtonPressed(_ sender: UIButton) {
        //TODO: add view/or something related where user could search and select their star situation
    }
    
}
extension InterviewAnswerDetailController: UITextFieldDelegate {
    
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
            return answerStrings.count
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
            let answer = answerStrings[indexPath.row]
            cell.configureCell(answer: answer)
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
