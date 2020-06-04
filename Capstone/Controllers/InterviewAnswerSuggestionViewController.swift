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
        //halfFrame()
        configureLabel(for: interviewQuestion)
    }
    
    public func configureLabel(for question: InterviewQuestion?) {
        suggestionLabel.text = question?.suggestion
    }
    
//    public func halfFrame() {
//        let frame = UIScreen.main.bounds
//        let height: CGFloat = frame.height * 0.5
//        let width: CGFloat = frame.width
//        let x: CGFloat = frame.minX
//        let y: CGFloat = frame.midY
//        view.frame = CGRect(x: x, y: y, width: width, height: height)
//    }
}
