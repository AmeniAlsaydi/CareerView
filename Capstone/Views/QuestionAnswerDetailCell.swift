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
        //let purple = #colorLiteral(red: 0.305962503, green: 0.1264642179, blue: 0.6983457208, alpha: 1)
        //self.layer.borderColor = purple as! CGColor
        self.layer.cornerRadius = 13
    }
    public func configureCell(answer: String) {
        userAnswerLabel.text = answer
    }
}
