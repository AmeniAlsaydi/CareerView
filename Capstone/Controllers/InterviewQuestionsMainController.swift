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
    case saved //TODO: Add user favorite questions
    case all
}

class InterviewQuestionsMainController: UIViewController {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var listener: ListenerRegistration?
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTapScreen(_:)))
        return tap
    }()
    
    public var filterState: FilterState = .all {
        didSet {
            self.questionsCollectionView.reloadData()
        }
    }
    private var commonInterviewQuestions = [InterviewQuestion]()
    private var customQuestions = [InterviewQuestion]()
    private var allQuestions = [InterviewQuestion]() {
        didSet {
            self.questionsCollectionView.reloadData()
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
                    //case .saved:
                //TODO
                default:
                    self.allQuestions = self.allQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let user = Auth.auth().currentUser else {return}
        listener = Firestore.firestore().collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.customQuestionsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                print("listener could not recieve changes for custom questions error: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let customQs = snapshot.documents.map {InterviewQuestion($0.data())}
                self?.customQuestions = customQs
                self?.allQuestions.append(contentsOf: customQs)
                self?.questionsCollectionView.reloadData()
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureCollectionView()
        configureNavBar()
        getInterviewQuestions()
        getUserCreatedQuestions()
        view.addGestureRecognizer(tapGesture)
    }
    override func viewDidDisappear(_ animated: Bool) {
        listener?.remove()
    }
    //MARK:- Config NavBar and Bar Button Method
    private func configureNavBar() {
        navigationItem.title = "Interview Questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addInterviewQuestionButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(presentfilterMenuButtonPressed(_:)))
    }
    @objc func addInterviewQuestionButtonPressed(_ sender: UIBarButtonItem) {
        let interviewQuestionEntryVC = InterviewQuestionEntryController(nibName: "InterviewQuestionEntryXib", bundle: nil)
        present(UINavigationController(rootViewController: interviewQuestionEntryVC), animated: true)
    }
    //MARK:- FilterMenu
    @objc func presentfilterMenuButtonPressed(_ sender: UIBarButtonItem) {
        let filterMenuVC = FilterMenuViewController(nibName: "FilterMenuViewControllerXib", bundle: nil)
        filterMenuVC.delegate = self
        self.addChild(filterMenuVC, frame: view.frame)
        filterMenuVC.filterState = filterState
    }
    @objc func didTapScreen(_ sender: UIGestureRecognizer) {
        let filterMenuVC = FilterMenuViewController(nibName: "FilterMenuViewControllerXib", bundle: nil)
        self.removeChild(childController: filterMenuVC)
    }
    //MARK:- Config Collection View
    private func configureCollectionView() {
        questionsCollectionView.keyboardDismissMode = .onDrag
        questionsCollectionView.delegate = self
        questionsCollectionView.dataSource = self
        questionsCollectionView.register(UINib(nibName: "InterviewQuestionCellXib", bundle: nil), forCellWithReuseIdentifier: "interviewQuestionCell")
    }
    //MARK:- Get Data
    private func getInterviewQuestions() {
        DatabaseService.shared.fetchCommonInterviewQuestions { [weak self] (result) in
            switch result {
            case .failure(let error) :
                print("could not fetch common interview questions from firebase error: \(error.localizedDescription)")
            case .success(let questions):
                DispatchQueue.main.async {
                    self?.commonInterviewQuestions = questions
                    self?.allQuestions.append(contentsOf: questions)
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
                    self?.customQuestions = customQuestions
                    self?.allQuestions.append(contentsOf: customQuestions)
                }
            }
        }
    }
}
//MARK:- CollectionView Delegate and DataSource
extension InterviewQuestionsMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width * 0.9
        let itemHeight: CGFloat = maxsize.height * 0.15
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let interviewAnswerVC = InterviewAnswerDetailController(nibName: "InterviewAnswerDetailXib", bundle: nil)
        if filterState == .all {
            let question = allQuestions[indexPath.row]
            interviewAnswerVC.question = question
        } else if filterState == .common {
            let question = commonInterviewQuestions[indexPath.row]
            interviewAnswerVC.question = question
        } else {
            let question = customQuestions[indexPath.row]
            interviewAnswerVC.question = question
        } //TODO: add favorites
        navigationController?.pushViewController(interviewAnswerVC, animated: true)
    }
}
extension InterviewQuestionsMainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterState == .all {
            return allQuestions.count
        } else if filterState == .common {
            return commonInterviewQuestions.count
        } else if filterState == .custom {
            return customQuestions.count
        } else if filterState == .saved {
            //TODO: logic for saved question
            return allQuestions.count
        }
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = questionsCollectionView.dequeueReusableCell(withReuseIdentifier: "interviewQuestionCell", for: indexPath) as? InterviewQuestionCell else {
            fatalError("could not cast to interviewquestioncell")
        }
        if filterState == .all {
            let question = allQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
        } else if filterState == .common {
            let question = commonInterviewQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
        } else if filterState == .custom {
            let question = customQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
        } else if filterState == .saved {
            //TODO: logic for saved question
            let question = allQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
            cell.currentQuestion = question
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
//MARK:- Extenstion For Child View
extension InterviewQuestionsMainController {
    func addChild(_ childController: UIViewController, frame: CGRect? = nil) {
        //add child view controller
        addChild(childController)
        //set the size of the child view controller's frame to half the parent view controller's height
        if let frame = frame {
            let height: CGFloat = frame.height
            let width: CGFloat = frame.width / 2
            let x: CGFloat = frame.minX
            let y: CGFloat = frame.minY
            childController.view.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        //add the childcontroller's view as the parent view controller's subview
        view.addSubview(childController.view)
        view.backgroundColor = .systemGray
        questionsCollectionView.alpha = 0.5
        searchBar.alpha = 0.5
        //pass child to parent
        childController.didMove(toParent: self)
    }
    func removeChild(childController: UIViewController) {
        //willMove assigns next location for this child view controller. since we dont need it elsewhere, we assign it to nil
        willMove(toParent: nil)
        //remove the child view controller's view from parent's view
        childController.view.removeFromSuperview()
        //remove child view controller from parent view controller
        childController.removeFromParent()
        view.backgroundColor = .systemBackground
        questionsCollectionView.alpha = 1
        searchBar.alpha = 1
    }
}
extension InterviewQuestionsMainController: FilterStateDelegate {
    func didAddFilter(_ filterState: FilterState, child: FilterMenuViewController) {
        self.filterState = filterState
        removeChild(childController: child)
    }
    func pressedCancel(child: FilterMenuViewController) {
        removeChild(childController: child)
    }
}
extension InterviewQuestionsMainController: InterviewQuestionCellDelegate {
    func presentMenu(cell: InterviewQuestionCell, question: InterviewQuestion) {
        guard let indexPath = questionsCollectionView.indexPath(for: cell) else {
            return
        }
        let customQuestion = allQuestions[indexPath.row] //TODO: refactor for custom q only
        cell.currentQuestion = customQuestion
        
        let optionsMenu = UIAlertController(title: "Custom Question Options", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit Custom Question", style: .default) { [weak self] (action) in
            let interviewQuestionEntryVC = InterviewQuestionEntryController(nibName: "InterviewQuestionEntryXib", bundle: nil)
            interviewQuestionEntryVC.editingMode = true
            interviewQuestionEntryVC.customQuestion = customQuestion
            self?.present(UINavigationController(rootViewController: interviewQuestionEntryVC), animated: true)
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            //TODO: need "Delete Custom Question" Database function
            self?.getUserCreatedQuestions()
            self?.questionsCollectionView.reloadData()
            print("could not delete")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.dismiss(animated: true)
        }
        optionsMenu.addAction(edit)
        optionsMenu.addAction(delete)
        optionsMenu.addAction(cancel)
        present(optionsMenu, animated: true, completion: nil)
    }
}
