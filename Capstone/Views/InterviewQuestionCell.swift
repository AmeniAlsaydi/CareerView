//
//  InterviewQuestionCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol InterviewQuestionCellDelegate: AnyObject  {
    func presentMenu(cell: InterviewQuestionCell, question: InterviewQuestion)
}
class InterviewQuestionCell: UICollectionViewCell {
    @IBOutlet weak var numberOfStarsLabel: UILabel!
    @IBOutlet weak var answerCheckBox: UIImageView!
    @IBOutlet weak var interviewQuestionLabel: UILabel!
    @IBOutlet weak var connectedStarsLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cellHeaderView: UIView!
    
    weak var delegate: InterviewQuestionCellDelegate?
    var currentQuestion: InterviewQuestion?
    
    override func layoutSubviews() {
        self.layer.cornerRadius = AppRoundedViews.cornerRadius
        self.backgroundColor = AppColors.systemBackgroundColor
        setAppColorsandFonts()
    }
    private func setAppColorsandFonts() {
        interviewQuestionLabel.font = AppFonts.semiBoldLarge
        connectedStarsLabel.font = AppFonts.subtitleFont
        connectedStarsLabel.textColor = AppColors.darkGrayHighlightColor
        numberOfStarsLabel.font = AppFonts.subtitleFont
        numberOfStarsLabel.textColor = AppColors.darkGrayHighlightColor
        answeredLabel.font = AppFonts.subtitleFont
        answeredLabel.textColor = AppColors.darkGrayHighlightColor
        answerCheckBox.tintColor = AppColors.darkGrayHighlightColor
        cellHeaderView.backgroundColor = AppColors.primaryPurpleColor
        //AppColors.colors.gradientBackground(view: cellHeaderView)
        editButton.tintColor = AppColors.secondaryPurpleColor
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print("edit button pressed")
        delegate?.presentMenu(cell: self, question: currentQuestion!)
    }
    
    public func configureCell(interviewQ: InterviewQuestion) {
        interviewQuestionLabel.text = interviewQ.question
        getUserAnswers(for: interviewQ)
    }
    private func getUserAnswers(for question: InterviewQuestion) {
        DatabaseService.shared.fetchAnsweredQuestions(questionString: question.question) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("unable to fetch user answers for interview question cell error: \(error.localizedDescription)")
            case .success(let answers):
                DispatchQueue.main.async {
                    let answer = answers.first
                    if answer?.answers.count ?? -1 > 0 {
                        self?.answerCheckBox.image = UIImage(systemName: "checkmark.square")
                    } else {
                        self?.answerCheckBox.image = UIImage(systemName: "square")
                    }
                    
                    if answer?.starSituationIDs.count ?? -1 > 0 {
                        self?.numberOfStarsLabel.text = answer?.starSituationIDs.count.description
                    } else {
                        self?.numberOfStarsLabel.text = "0"
                    }
                    
                    
                }
            }
        }
    }
    
}
