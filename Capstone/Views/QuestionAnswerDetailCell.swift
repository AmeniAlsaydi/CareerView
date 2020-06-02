//
//  InterviewAnswerCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class QuestionAnswerDetailCell: UICollectionViewCell {
    @IBOutlet weak var userAnswerLabel: UILabel!
    
    public func configureCell(answer: String) {
        userAnswerLabel.text = answer
    }
}
