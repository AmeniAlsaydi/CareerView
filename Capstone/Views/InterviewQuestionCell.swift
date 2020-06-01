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
    
    public func configureCell(interviewQ: InterviewQuestion, answer: InterviewAnswer? = nil) {
        interviewQuestionLabel.text = interviewQ.question
        numberOfStarsLabel.text = answer?.starSituationIDs.count.description ?? "0"
        if answer == nil {
            answerCheckBox.image = UIImage(systemName: "square")
        } else {
            answerCheckBox.image = UIImage(systemName: "checkmark.rectangle")
        }
    }
    
}
