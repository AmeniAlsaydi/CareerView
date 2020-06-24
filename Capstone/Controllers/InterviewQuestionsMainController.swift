//
//  InterviewQuestionsMainController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

enum FilterState {
    case common
    case custom
    case bookmarked
    case all
}

class InterviewQuestionsMainController: UIViewController {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButtonsStack: UIStackView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var bookmarksButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var collectionViewTopAnchor: NSLayoutConstraint!
    
    private var listener: ListenerRegistration?
    
    private var isFilterOn = false {
        didSet {
            if isFilterOn {
                collectionViewTopAnchor.constant = 8
                filterButtonsStack.isHidden = false
            } else {
                    self.collectionViewTopAnchor.constant = -44
                    self.filterButtonsStack.isHidden = true
                    self.getInterviewQuestions()
            }
        }
    }
    
    public var filterState: FilterState = .all {
        didSet {
            questionsCollectionView.reloadData()
            allQuestions = Array(allQuestions).removingDuplicates()
        }
    }
    
    private var commonInterviewQuestions = [InterviewQuestion]() {
        didSet{
            if filterState == .common {
                questionsCollectionView.reloadData()
            }
        }
    }
    
    private var customQuestions = [InterviewQuestion]() {
        didSet {
            questionsCollectionView.reloadData()
        }
    }
    
    private var allQuestions = [InterviewQuestion]() {
        didSet {
                allQuestions = Array(allQuestions).removingDuplicates()
                questionsCollectionView.reloadData()
                questionsCollectionView.backgroundView = nil
        }
    }
    
    private var bookmarkedQuestions = [InterviewQuestion]() {
        didSet {
        }
    }
    
    private var searchQuery = String() {
        didSet {
            DispatchQueue.main.async {
                switch self.filterState {
                case .all:
                    self.allQuestions = self.allQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
                case .common:
                    self.commonInterviewQuestions = self.commonInterviewQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
                case .custom:
                    self.customQuestions = self.customQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
                case .bookmarked:
                    self.bookmarkedQuestions = self.bookmarkedQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateUI()
        configureCollectionView()
        configureNavBar()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getInterviewQuestions()
        getBookmarkedQuestions()
        guard let user = Auth.auth().currentUser else {return}
        listener = Firestore.firestore().collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.customQuestionsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                print("listener could not recieve changes for custom questions error: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let customQs = snapshot.documents.map {InterviewQuestion($0.data())}
                self?.getUserCreatedQuestions()
                self?.getBookmarkedQuestions()
                self?.questionsCollectionView.reloadData()
                self?.customQuestions = customQs
            }
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        allQuestions.removeAll()
        listener?.remove()
    }
    
    //MARK:- UI
    private func updateUI() {
        view.backgroundColor = AppColors.complimentaryBackgroundColor
        isFilterOn = false
        questionsCollectionView.backgroundColor = .clear
        buttonsUI()
        roundButtons()
    }
    
    private func buttonsUI() {
        allButton.titleLabel?.font = AppFonts.subtitleFont
        bookmarksButton.titleLabel?.font = AppFonts.subtitleFont
        commonButton.titleLabel?.font = AppFonts.subtitleFont
        customButton.titleLabel?.font = AppFonts.subtitleFont
        allButton.tintColor = AppColors.whiteTextColor
        allButton.backgroundColor = AppColors.secondaryPurpleColor
        bookmarksButton.tintColor = AppColors.whiteTextColor
        bookmarksButton.backgroundColor = AppColors.secondaryPurpleColor
        commonButton.tintColor = AppColors.whiteTextColor
        commonButton.backgroundColor = AppColors.secondaryPurpleColor
        customButton.tintColor = AppColors.whiteTextColor
        customButton.backgroundColor = AppColors.secondaryPurpleColor
    }
    
    private func roundButtons() {
        allButton.layer.cornerRadius = 13
        bookmarksButton.layer.cornerRadius = 13
        commonButton.layer.cornerRadius = 13
        customButton.layer.cornerRadius = 13
    }
    
    //MARK:- Config NavBar and Bar Button Method
    private func configureNavBar() {
        navigationItem.title = "Interview Questions"
        AppButtonIcons.buttons.navBarBackButtonItem(navigationItem: navigationItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.plusIcon, style: .plain, target: self, action: #selector(addInterviewQuestionButtonPressed(_:)))
        let infoButton = UIBarButtonItem(image: AppButtonIcons.infoIcon, style: .plain, target: self, action: #selector(presentInfoVC(_:)))
        let filterButton = UIBarButtonItem(image: AppButtonIcons.filterIcon, style: .plain, target: self, action: #selector(presentfilterMenuButtonPressed(_:)))
        navigationItem.leftBarButtonItems = [filterButton, infoButton]
    }
    @objc func addInterviewQuestionButtonPressed(_ sender: UIBarButtonItem) {
        let interviewQuestionEntryVC = InterviewQuestionEntryController(nibName: "InterviewQuestionEntryXib", bundle: nil)
        present(UINavigationController(rootViewController: interviewQuestionEntryVC), animated: true)
    }
    @objc func presentfilterMenuButtonPressed(_ sender: UIBarButtonItem) {
        isFilterOn.toggle()
    }
    @objc func presentInfoVC(_ sender: UIBarButtonItem) {
        let infoViewController = MoreInfoViewController(nibName: "MoreInfoControllerXib", bundle: nil)
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.modalPresentationStyle = .overFullScreen
        infoViewController.enterFrom = .interviewQuestionsMain
        present(infoViewController, animated: true)
    }
    //MARK:- Config Collection View
    private func configureCollectionView() {
        questionsCollectionView.keyboardDismissMode = .onDrag
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
        questionsCollectionView.register(UINib(nibName: "InterviewQuestionCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewQuestionCell")
        if let flowLayout = flowLayout,
            let collectionView = questionsCollectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }
    
    //MARK:- Get Data
    private func getInterviewQuestions() {
        self.showIndicator()
        DatabaseService.shared.fetchCommonInterviewQuestions { [weak self] (result) in
            switch result {
            case .failure(let error) :
                self?.removeIndicator()
                print("could not fetch common interview questions from firebase error: \(error.localizedDescription)")
            case .success(let questions):
                DispatchQueue.main.async {
                    self?.removeIndicator()
                    self?.commonInterviewQuestions = questions
                    self?.allQuestions.append(contentsOf: questions)
                    self?.checkForEmptyCustomQuestionsArray()
                }
            }
        }
    }
    
    private func getUserCreatedQuestions() {
        DatabaseService.shared.fetchCustomInterviewQuestions { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to retrieve custom questions error: \(error.localizedDescription)")
            case .success(let customQuestions):
                DispatchQueue.main.async {
                    print("custom questions count: \(customQuestions.count)")
                    self?.customQuestions = customQuestions
                    self?.allQuestions.append(contentsOf: customQuestions)
                    self?.checkForEmptyCustomQuestionsArray()
                }
            }
        }
    }
    
    private func getBookmarkedQuestions() {
        DatabaseService.shared.fetchBookmarkedQuestions { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to retrieve bookmarked questions error: \(error.localizedDescription)")
            case .success(let bookmarks):
                DispatchQueue.main.async {
                    self?.bookmarkedQuestions = bookmarks
                    self?.checkForEmptyBookMarkQuestionsArray()
                }
            }
        }
    }
    
    @IBAction func allButtonPressed(_ sender: UIButton) {
        allButton.tintColor = AppColors.whiteTextColor
        allButton.backgroundColor = AppColors.primaryPurpleColor
        bookmarksButton.tintColor = AppColors.whiteTextColor
        bookmarksButton.backgroundColor = AppColors.secondaryPurpleColor
        commonButton.tintColor = AppColors.whiteTextColor
        commonButton.backgroundColor = AppColors.secondaryPurpleColor
        customButton.tintColor = AppColors.whiteTextColor
        customButton.backgroundColor = AppColors.secondaryPurpleColor
        filterState = .all
        allQuestions.removeAll()
        getUserCreatedQuestions()
        getInterviewQuestions()
    }
    
    @IBAction func bookmarksButtonPressed(_ sender: UIButton) {
        allButton.tintColor = AppColors.whiteTextColor
        allButton.backgroundColor = AppColors.secondaryPurpleColor
        bookmarksButton.tintColor = AppColors.whiteTextColor
        bookmarksButton.backgroundColor = AppColors.primaryPurpleColor
        commonButton.tintColor = AppColors.whiteTextColor
        commonButton.backgroundColor = AppColors.secondaryPurpleColor
        customButton.tintColor = AppColors.whiteTextColor
        customButton.backgroundColor = AppColors.secondaryPurpleColor
        filterState = .bookmarked
        getBookmarkedQuestions()
    }
    
    @IBAction func commonButtonPressed(_ sender: UIButton) {
        allButton.tintColor = AppColors.whiteTextColor
        allButton.backgroundColor = AppColors.secondaryPurpleColor
        bookmarksButton.tintColor = AppColors.whiteTextColor
        bookmarksButton.backgroundColor = AppColors.secondaryPurpleColor
        commonButton.tintColor = AppColors.whiteTextColor
        commonButton.backgroundColor = AppColors.primaryPurpleColor
        customButton.tintColor = AppColors.whiteTextColor
        customButton.backgroundColor = AppColors.secondaryPurpleColor
        filterState = .common
    }
    
    @IBAction func customButtomPressed(_ sender: UIButton) {
        allButton.tintColor = AppColors.whiteTextColor
        allButton.backgroundColor = AppColors.secondaryPurpleColor
        bookmarksButton.tintColor = AppColors.whiteTextColor
        bookmarksButton.backgroundColor = AppColors.secondaryPurpleColor
        commonButton.tintColor = AppColors.whiteTextColor
        commonButton.backgroundColor = AppColors.secondaryPurpleColor
        customButton.tintColor = AppColors.whiteTextColor
        customButton.backgroundColor = AppColors.primaryPurpleColor
        filterState = .custom
        getUserCreatedQuestions()
    }
    private func checkForEmptyCustomQuestionsArray() {
        if filterState == .custom {
            questionsCollectionView.reloadData()
            if customQuestions.isEmpty {
                questionsCollectionView.backgroundView = EmptyView.init(title: "No Custom Questions Created", message: "Add a question by pressing the plus button", imageName: "questionmark.square.fill")
            } else {
                print("custom questions NOT empty")
                questionsCollectionView.reloadData()
                questionsCollectionView.backgroundView = nil
                customQuestions = Array(customQuestions).removingDuplicates()
            }
        }
    }
    private func checkForEmptyBookMarkQuestionsArray() {
        if filterState == .bookmarked {
            questionsCollectionView.reloadData()
            if bookmarkedQuestions.isEmpty {
                questionsCollectionView.backgroundView = EmptyView.init(title: "You Have No Bookmarks", message: "Add to your bookmarks collection by selecting an interview question and pressing the bookmark button", imageName: "bookmark")
            } else {
                questionsCollectionView.reloadData()
                questionsCollectionView.backgroundView = nil
            }
        }

    }
}

//MARK:- CollectionView Delegate and DataSource
extension InterviewQuestionsMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = view.frame.size
        let itemWidth: CGFloat = maxsize.width * 0.9
        let itemHeight: CGFloat = maxsize.height * 0.2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interviewAnswerVC = InterviewAnswerDetailController(nibName: "InterviewAnswerDetailXib", bundle: nil)
        switch filterState{
        case .all:
            let question = allQuestions[indexPath.row]
            interviewAnswerVC.question = question
        case.common:
            let question = commonInterviewQuestions[indexPath.row]
            interviewAnswerVC.question = question
        case .custom:
            let question = customQuestions[indexPath.row]
            interviewAnswerVC.question = question
        case.bookmarked:
            let question = bookmarkedQuestions[indexPath.row]
            interviewAnswerVC.question = question
        }
        navigationController?.pushViewController(interviewAnswerVC, animated: true)
    }
}

extension InterviewQuestionsMainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch filterState {
        case .all:
            return allQuestions.count
        case .bookmarked:
            return bookmarkedQuestions.count
        case .custom:
            return customQuestions.count
        case .common:
            return commonInterviewQuestions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = questionsCollectionView.dequeueReusableCell(withReuseIdentifier: "interviewQuestionCell", for: indexPath) as? InterviewQuestionCell else {
            fatalError("could not cast to interviewquestioncell")
        }
        
        switch filterState {
        case .all:
            let question = allQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
            let customQs = customQuestions.map {$0.question}
            if customQs.contains(question.question) {
                cell.editButton.isHidden = false
            } else {
                cell.editButton.isHidden = true
            }
        case .common:
            let question = commonInterviewQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
            let customQs = customQuestions.map {$0.question}
            if customQs.contains(question.question) {
                cell.editButton.isHidden = false
            } else {
                cell.editButton.isHidden = true
            }
        case .custom:
            let question = customQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
            cell.editButton.isHidden = false
        case .bookmarked:
            let question = bookmarkedQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
            let customQs = customQuestions.map {$0.question}
            if customQs.contains(question.question) {
                cell.editButton.isHidden = false
            } else {
                cell.editButton.isHidden = true
            }
        }
        cell.delegate = self
        return cell
    }
}

//MARK:- Search Bar Delegate
extension InterviewQuestionsMainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty ?? false) {
            getInterviewQuestions()
        } else {
            searchQuery = searchBar.text ?? ""
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
extension InterviewQuestionsMainController: InterviewQuestionCellDelegate {
    
    func presentMenu(cell: InterviewQuestionCell, question: InterviewQuestion) {
        self.showIndicator()
        guard let indexPath = questionsCollectionView.indexPath(for: cell) else {
            return
        }
        let customQuestion: InterviewQuestion?
        if filterState == .custom {
            customQuestion = customQuestions[indexPath.row]
            cell.currentQuestion = customQuestion
        } else {
            customQuestion = allQuestions[indexPath.row]
            cell.currentQuestion = customQuestion
        }
        
        let optionsMenu = UIAlertController(title: "Custom Question Options", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit Custom Question", style: .default) { [weak self] (action) in
            let interviewQuestionEntryVC = InterviewQuestionEntryController(nibName: "InterviewQuestionEntryXib", bundle: nil)
            interviewQuestionEntryVC.editingMode = true
            interviewQuestionEntryVC.customQuestion = customQuestion
            interviewQuestionEntryVC.delegate = self
            self?.present(UINavigationController(rootViewController: interviewQuestionEntryVC), animated: true)
        }
        let delete = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (action) in
            DatabaseService.shared.deleteCustomQuestion(customQuestion: customQuestion!) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.removeIndicator()
                        self?.showAlert(title: "Error", message: "Could not remove question at this time error: \(error.localizedDescription)")
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.removeIndicator()
                        self?.showAlert(title: "Question Removed", message: "\(customQuestion!.question) has been removed")
                        if self?.filterState == .custom {
                            if !(self?.customQuestions.isEmpty ?? false) {
                                self?.questionsCollectionView.reloadData()
                            }
                        } else {
                            if (self?.bookmarkedQuestions.contains(question))! {
                                self?.deleteFromBookmarks(question: question)
                            }
                            self?.allQuestions.remove(at: indexPath.row)
                            self?.questionsCollectionView.reloadData()
                        }
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.dismiss(animated: true)
        }
        optionsMenu.addAction(edit)
        optionsMenu.addAction(delete)
        optionsMenu.addAction(cancel)
        present(optionsMenu, animated: true, completion: nil)
    }
    private func deleteFromBookmarks(question: InterviewQuestion) {
        DatabaseService.shared.removeQuestionFromBookmarks(question: question) { (result) in
            switch result {
            case .failure(let error):
                print("unable to remove custom question from bookmarks: \(error.localizedDescription)")
            case .success:
                print("removed from bookmarks")
            }
        }
    }
}
extension InterviewQuestionsMainController: EditInterviewQuestionDelegate {
    func didEditInterviewQuestion() {
        allQuestions.removeAll()
        getUserCreatedQuestions()
        getInterviewQuestions()
        questionsCollectionView.reloadData()
    }
}

