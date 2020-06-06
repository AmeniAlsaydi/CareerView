//
//  InterviewQuestionsMainController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewQuestionsMainController: UIViewController {
    
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var interviewQuestions = [InterviewQuestion]() {
        didSet {
            self.questionsCollectionView.reloadData()
        }
    }
    private var searchQuery = String() {
        didSet {
            DispatchQueue.main.async {
                self.interviewQuestions = self.interviewQuestions.filter {$0.question.lowercased().contains(self.searchQuery.lowercased())}
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureCollectionView()
        configureNavBar()
        getInterviewQuestions()
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
    @objc func filterQuestionsButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: add a way for user to filter
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
                    self?.interviewQuestions = questions
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
                    self?.interviewQuestions.append(contentsOf: customQuestions)
                }
            }
        }
    }
}
//MARK:- COllectionView Delegate and DataSource
extension InterviewQuestionsMainController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width * 0.9
        let itemHeight: CGFloat = maxsize.height * 0.15
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let question = interviewQuestions[indexPath.row]
        let interviewAnswerVC = InterviewAnswerDetailController(nibName: "InterviewAnswerDetailXib", bundle: nil)
        interviewAnswerVC.question = question
        show(interviewAnswerVC, sender: nil)
    }
}
extension InterviewQuestionsMainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interviewQuestions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = questionsCollectionView.dequeueReusableCell(withReuseIdentifier: "interviewQuestionCell", for: indexPath) as? InterviewQuestionCell else {
            fatalError("could not cast to interviewquestioncell")
        }
        let question = interviewQuestions[indexPath.row]
        cell.configureCell(interviewQ: question)
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
