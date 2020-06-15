//
//  InterviewQuestionEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class InterviewQuestionEntryController: UIViewController {
    
    @IBOutlet weak var questionTextfield: UITextField!
    @IBOutlet weak var addStarStoryButton: UIButton!
    @IBOutlet weak var addAnswerButton: UIButton!
    @IBOutlet weak var cancelAddAnswerButton: UIButton!
    @IBOutlet weak var confirmAddAnswerButton: UIButton!
    @IBOutlet weak var answerTextfield: UITextField!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    @IBOutlet weak var starsCollectionView: UICollectionView!
    @IBOutlet weak var addAnswerLabel: UILabel!
    @IBOutlet weak var addStarStoryLabel: UILabel!
    
    private var listener: ListenerRegistration?
    var editingMode = false
    var customQuestion: InterviewQuestion?
    var createdQuestion: InterviewQuestion?
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
            starsCollectionView.reloadData()
            if starStories.isEmpty {
                starsCollectionView.backgroundView = EmptyView.init(title: "No STAR Stories", message: "Add your story by pressing the add button", imageName: "plus.circle")
            } else {
                starsCollectionView.reloadData()
                starsCollectionView.backgroundView = nil
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let user = Auth.auth().currentUser else {return}
        listener = Firestore.firestore().collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.answeredQuestionsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                print("listener could not recieve changes for user answers error: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let userAnswers = snapshot.documents.map { AnsweredQuestion($0.data()) }
                self?.answers = userAnswers.filter {$0.question == self?.createdQuestion?.question}
                self?.getUserSTARS()
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureCollectionViews()
        configureNavBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    private func updateUI() {
        if editingMode {
            questionTextfield.text = customQuestion?.question
            navigationItem.title = "Edit Custom Question"
            cancelAddAnswerButton.isHidden = true
            confirmAddAnswerButton.isHidden = true
            answerTextfield.isHidden = true
            answerTextfield.text = ""
            answersCollectionView.isHidden = true
            addAnswerButton.isHidden = true
            addStarStoryButton.isHidden = true
            starsCollectionView.isHidden = true
            addAnswerLabel.isHidden = true
            addStarStoryLabel.isHidden = true
        } else {
            questionTextfield.text = ""
            navigationItem.title = "Add A Custom Question"
            hideAddAnswerElements()
        }
    }
    private func hideAddAnswerElements() {
        cancelAddAnswerButton.isHidden = true
        confirmAddAnswerButton.isHidden = true
        answerTextfield.isHidden = true
        answerTextfield.text = ""
        answersCollectionView.isHidden = false
        addAnswerButton.isHidden = false
    }
    private func showAddAnswerElements() {
        cancelAddAnswerButton.isHidden = false
        confirmAddAnswerButton.isHidden = false
        answerTextfield.isHidden = false
        answersCollectionView.isHidden = true
        addAnswerButton.isHidden = true
    }
    private func configureCollectionViews() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        answersCollectionView.register(UINib(nibName: "QuestionAnswerDetailCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewAnswerCell")
        starsCollectionView.delegate = self
        starsCollectionView.dataSource = self
        starsCollectionView.register(UINib(nibName: "StarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "starSituationCell")
    }
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(createQuestionButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
    }
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @objc private func createQuestionButtonPressed(_ sender: UIBarButtonItem){
        if editingMode {
            guard var question = customQuestion, let questionText = questionTextfield.text, !questionText.isEmpty else {
                return
            }
            question.question = questionText
            DatabaseService.shared.updateCustomQuestion(customQuestion: question) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Could not update \(questionText) at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Question Updated", message: "Question has now been updated with changes", completion: { (action) in
                            self?.dismiss(animated: true)
                        })
                    }
                }
            }
        } else {
            guard let questionText = questionTextfield.text, !questionText.isEmpty else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Missing Fields", message: "You will need to enter a question first")
                }
                return
            }
            let newQuestion = InterviewQuestion(question: questionText, suggestion: nil, id: UUID().uuidString)
            createdQuestion = newQuestion
            DatabaseService.shared.addCustomInterviewQuestion(customQuestion: newQuestion) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Could not create your custom question at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Question Added", message: "You can now add an answer and/or attach a STAR Story to the question", completion: { (action) in
                            self?.dismiss(animated: true)
                        })
                    }
                }
            }
        }
    }
    private func getUserAnswers() {
        DatabaseService.shared.fetchAnsweredQuestions(questionString: createdQuestion?.question ?? "") { [weak self] (result) in
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
                    self?.starStories = stars
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
    @IBAction func confirmAddAnswerButtonPressed(_ sender: UIButton) {
        guard let answer = answerTextfield.text, !answer.isEmpty else {
            confirmAddAnswerButton.isEnabled = false
            return
        }
        newAnswers.append(answer)
        if answers.count == 0 {
            let newAnswer = AnsweredQuestion(id: UUID().uuidString, question: createdQuestion?.question ?? "could not pass question", answers: newAnswers, starSituationIDs: newStarStoryIDs)
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
    @IBAction func cancelAddAnswerButtonPressed(_ sender: UIButton) {
        hideAddAnswerElements()
    }
    @IBAction func addAnswerButtonPressed(_ sender: UIButton) {
        showAddAnswerElements()
    }
    @IBAction func addStarStoryButtonPressed(_ sender: UIButton) {
        let starStoryVC = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        starStoryVC.isAddingToAnswer = true
        starStoryVC.answerId = answers.first?.id
        starStoryVC.question = createdQuestion?.question
        present(UINavigationController(rootViewController: starStoryVC), animated: true)
    }
}

extension InterviewQuestionEntryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width * 0.8
        return CGSize(width: itemWidth, height: itemWidth * 0.5)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
extension InterviewQuestionEntryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == answersCollectionView {
            return answerStrings.count
        } else {
            return starStories.count
        }
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
            guard let cell = starsCollectionView.dequeueReusableCell(withReuseIdentifier: "starSituationCell", for: indexPath) as? StarSituationCell else {
                fatalError("could not cast to StarSituationCell")
            }
            let story = starStories[indexPath.row]
            cell.configureCell(starSituation: story)
            return cell
        }
    }
}
