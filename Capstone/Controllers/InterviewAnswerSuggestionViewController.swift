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
    
    var interviewQuestion: InterviewQuestion?
    
    override func viewDidLoad() {
        configureLabel(for: interviewQuestion)
    }
    public func configureLabel(for question: InterviewQuestion?) {
        suggestionLabel.text = question?.suggestion
    }
    
}
