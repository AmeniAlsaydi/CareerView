//
//  InterviewAnswerCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class QuestionAnswerDetailCell: UICollectionViewCell {
    //MARK:- IBoutlets
    @IBOutlet weak var userAnswerLabel: UILabel!
    //MARK:- LayoutSubViews
    override func layoutSubviews() {
        self.layer.cornerRadius = 13
        self.backgroundColor = AppColors.systemBackgroundColor
    }
    //MARK:- Funtion
    public func configureCell(answer: String) {
        userAnswerLabel.font = AppFonts.primaryFont
        userAnswerLabel.text = answer
    }
}
