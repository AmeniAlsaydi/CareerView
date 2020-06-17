//
//  InterviewQuestionEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewQuestionEntryController: UIViewController {
    
    @IBOutlet weak var questionTextfield: UITextField!
    
    var editingMode = false
    var customQuestion: InterviewQuestion?
    var createdQuestion: InterviewQuestion?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureNavBar()
    }
    private func updateUI() {
        if editingMode {
            questionTextfield.text = customQuestion?.question
            navigationItem.title = "Edit Custom Question"
        } else {
            questionTextfield.text = ""
            navigationItem.title = "Add A Custom Question"
        }
    }
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.checkmarkIcon, style: .plain, target: self, action: #selector(createQuestionButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.xmarkIcon, style: .plain, target: self, action: #selector(cancelButtonPressed(_:)) )
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
}

