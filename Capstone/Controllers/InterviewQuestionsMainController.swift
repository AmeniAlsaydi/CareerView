//
//  InterviewQuestionsMainController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

enum FilterState {
    case common
    case custom
    case saved //TODO: Add user favorite questions
    case all
}

class InterviewQuestionsMainController: UIViewController {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
                self.commonInterviewQuestions = self.commonInterviewQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureCollectionView()
        configureNavBar()
        getInterviewQuestions()
        getUserCreatedQuestions()
    }
    //MARK:- Config NavBar and Bar Button Method
    private func configureNavBar() {
        navigationItem.title = "Interview Questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addInterviewQuestionButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterQuestionsButtonPressed(_:)))
    }
    @objc func addInterviewQuestionButtonPressed(_ sender: UIBarButtonItem) {
        let interviewQuestionEntryVC = InterviewQuestionEntryController(nibName: "InterviewQuestionEntryXib", bundle: nil)
        show(interviewQuestionEntryVC, sender: nil)
    }
    //MARK:- FilterMenu
    @objc func filterQuestionsButtonPressed(_ sender: UIBarButtonItem) {
        let filterMenuVC = FilterMenuViewController(nibName: "FilterMenuViewControllerXib", bundle: nil)
        filterMenuVC.delegate = self
        self.addChild(filterMenuVC, frame: view.frame)
    }
    //MARK:- Config Collection View
    private func configureCollectionView() {
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
        } else {
            return customQuestions.count
        } //TODO: favorites
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = questionsCollectionView.dequeueReusableCell(withReuseIdentifier: "interviewQuestionCell", for: indexPath) as? InterviewQuestionCell else {
            fatalError("could not cast to interviewquestioncell")
        }
        if filterState == .all {
            let question = allQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
        } else if filterState == .common {
            let question = commonInterviewQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
        } else if filterState == .custom {
            let question = customQuestions[indexPath.row]
            cell.configureCell(interviewQ: question)
        } //TODO: favorites
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
        view.layer.shadowOpacity = 0.3
        //view.layer.shadowColor =
        
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
        childController.removeFromParent()
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
