//
//  InterviewQuestionCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewQuestionCell: UICollectionViewCell {
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var answerCheckBox: UIImageView!
    @IBOutlet weak var interviewQuestionLabel: UILabel!
    
    override func layoutSubviews() {
        self.layer.borderWidth = 2
        //let purple = #colorLiteral(red: 0.305962503, green: 0.1264642179, blue: 0.6983457208, alpha: 1)
        //self.layer.borderColor = purple as! CGColor
        self.layer.cornerRadius = 13
    }
    public func configureCell(interviewQ: InterviewQuestion) {
        interviewQuestionLabel.text = interviewQ.question
        
        getUserAnswers(for: interviewQ)
        
    }
    private func getUserAnswers(for question: InterviewQuestion) {
        //TODO: need user answers to populate the interview cell with number of star stories and answers
        DatabaseService.shared.fetchAnsweredQuestions(questionString: question.question) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to fetch user answers for interview question cell error: \(error.localizedDescription)")
            case .success(let answers):
                DispatchQueue.main.async {
                    for answer in answers {
                        if answer.answers.count > 0 {
                            self?.answerCheckBox.image = UIImage(systemName: "checkmark.rectangle")
                            self?.numberOfStarsLabel.text = answer.starSituationIDs.count.description
                        } else {
                            self?.answerCheckBox.image = UIImage(systemName: "square")
                            self?.numberOfStarsLabel.text = "0"
                        }
                    }
                }
            }
        }
    }
    
}
