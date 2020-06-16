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
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var purpleView: UIView!
    
    var interviewQuestion: InterviewQuestion?
    
    override func viewDidLoad() {
        setAppColors()
        configureLabel(for: interviewQuestion)
    }
    private func setAppColors() {
        AppColors.colors.gradientBackground(view: purpleView)
        view.backgroundColor = .clear
        whiteView.layer.cornerRadius = 13
    }
    public func configureLabel(for question: InterviewQuestion?) {
        suggestionLabel.text = question?.suggestion
    }
}
