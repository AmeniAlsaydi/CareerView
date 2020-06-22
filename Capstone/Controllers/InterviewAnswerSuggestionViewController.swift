//
//  InterviewAnswerSuggestionView.swift
//  Capstone
//
//  Created by casandra grullon on 6/4/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewAnswerSuggestionViewController: UIViewController {
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var purpleView: UIView!
    @IBOutlet weak var answeringMethodsLabel: UILabel!
    
    var interviewQuestion: InterviewQuestion?
    var comingFromSTARSVC = false
    
    override func viewDidLoad() {
        setAppFonts()
        setAppColors()
        configureLabels(for: interviewQuestion)
    }
    private func setAppFonts() {
        suggestionLabel.font = AppFonts.primaryFont
        suggestionLabel.textColor = AppColors.primaryBlackColor
        promptLabel.font = AppFonts.boldFont
        promptLabel.textColor = AppColors.whiteTextColor
        directionsLabel.font = AppFonts.secondaryFont
        directionsLabel.textColor = AppColors.darkGrayHighlightColor
        answeringMethodsLabel.font = AppFonts.primaryFont
        answeringMethodsLabel.textColor = AppColors.darkGrayHighlightColor
    }
    private func setAppColors() {
        AppColors.colors.gradientBackground(view: purpleView)
        view.backgroundColor = .clear
        whiteView.layer.cornerRadius = 13
        purpleView.clipsToBounds = true
    }
    public func configureLabels(for question: InterviewQuestion? = nil) {
        if comingFromSTARSVC {
            promptLabel.text = "Understand the STAR method"
            suggestionLabel.text = "The STAR method allows you to respond to interview questions with real examples to prove to the interviewer that you possess the right skills and experience for the job. STAR stands for:\nSituation - describe a time when...\n\nTask - what task did you need to perfrom for the best outcome in the situation\n\nAction - what actions did you take?\n\nResult - describe the results of the actions you took. It is important to focus on STAR stories that ended with positive results."
            answeringMethodsLabel.text = "Add a STAR Story by pressing on the plus icon on the previous screen. \nYou can attach STAR Stories to your logged jobs and interview questions"
        } else {
            suggestionLabel.text = question?.suggestion
        }
    }
}
