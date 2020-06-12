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
    override func layoutSubviews() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 13
    }
    public func configureCell(answer: String) {
        userAnswerLabel.text = answer
    }
}
