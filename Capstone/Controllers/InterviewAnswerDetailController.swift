//
//  InterviewAnswerDetailController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class InterviewAnswerDetailController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    @IBOutlet weak var starStoriesCollectionView: UICollectionView!
    @IBOutlet weak var addAnswerButton: UIButton!
    @IBOutlet weak var enterAnswerTextfield: UITextField!
    @IBOutlet weak var confirmAddAnswerButton: UIButton!
    @IBOutlet weak var cancelAnswerButton: UIButton!
    
    private var listener: ListenerRegistration?
    public var question: InterviewQuestion?
    //MARK:- User Answer
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
    //MARK:- Star Stories
    private var newStarStoryIDs = [String]()
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
    //MARK:- ViewDidLoad/ViewWillAppear/ViewDidDisappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.answeredQuestionsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                print("listener could not recieve changes error: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let userAnswers = snapshot.documents.map { AnsweredQuestion($0.data())}
                self?.answers = userAnswers
                //self?.answerStrings = userAnswers.first?.answers ?? []
                //self?.answersCollectionView.reloadData()
                self?.updateUI()
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserSTARS()
        getUserAnswers()
        updateUI()
        enterAnswerTextfield.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    //MARK:- UI
    private func updateUI() {
        hideAddAnswerElements()
        configureNavBar()
        configureCollectionViews()
        questionLabel.text = question?.question
    }
    //MARK:- Collection View Config
    private func configureCollectionViews() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        answersCollectionView.register(UINib(nibName: "QuestionAnswerDetailCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewAnswerCell")
        starStoriesCollectionView.delegate = self
        starStoriesCollectionView.dataSource = self
        starStoriesCollectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
    }
    //MARK:- Config NavBar & Nav Bar Button functions
    private func configureNavBar() {
        let suggestionButton = UIBarButtonItem(image: UIImage(systemName: "lightbulb"), style: .plain, target: self, action: #selector(suggestionButtonPressed(_:)))
        let saveQuestionButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addQuestionToSavedQuestionsButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [saveQuestionButton, suggestionButton]
    }
    @objc private func suggestionButtonPressed(_ sender: UIBarButtonItem) {
        let interviewQuestionSuggestionViewController = InterviewAnswerSuggestionViewController(nibName: "InterviewAnswerSuggestionXib", bundle: nil)
        interviewQuestionSuggestionViewController.interviewQuestion = question
        present(interviewQuestionSuggestionViewController, animated: true)
    }
    @objc private func addQuestionToSavedQuestionsButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: Save question to a user's collection of saved questions
    }
    //MARK:- Hide/Show methods
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
    //MARK:- Get Data Methods
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
                    var results = [StarSituation]()
                    for star in stars {
                        if self?.answers.first?.starSituationIDs.contains(star.id) ?? false {
                            results.append(star)
                        }
                        
                    }
                    self?.starStories = results
                }
            }
        }
    }
    //MARK:- Button IBActions
    @IBAction func addAnswerButtonPressed(_ sender: UIButton){
        showAddAnswerElements()
    }
    @IBAction func cancelAddAnswerButtonPressed(_ sender: UIButton) {
        hideAddAnswerElements()
    }
    @IBAction func confirmAddAnswerButtonPressed(_ sender: UIButton) {
        guard let answer = enterAnswerTextfield.text, !answer.isEmpty else {
            confirmAddAnswerButton.isEnabled = false
            return
        }
        newAnswers.append(answer)
        if answers.count == 0 {
            let newAnswer = AnsweredQuestion(id: UUID().uuidString, question: question?.question ?? "could not pass question", answers: newAnswers, starSituationIDs: newStarStoryIDs)
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
                    
                }
            }
        }
        hideAddAnswerElements()
    }
    @IBAction func addSTARStoryButtonPressed(_ sender: UIButton) {
        let starStoryVC = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        starStoryVC.isAddingToAnswer = true
        starStoryVC.answerId = answers.first?.id
        starStoryVC.question = question?.question
        present(UINavigationController(rootViewController: starStoryVC), animated: true)
    }
}
//MARK:- Textfield Delegate
extension InterviewAnswerDetailController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confirmAddAnswerButton.isEnabled = true
    }
}
//MARK:- CollectionView Delegate & DataSource
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
