//
//  MoreInfoViewController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

enum EnterFromViewController {
    case jobHistory
    case starStories
    case interviewQuestionsMain
    case interviewAnswer
    case applicationsTracker
}

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoIconImageView: UIImageView!
    
    var enterFrom: EnterFromViewController = .jobHistory
    var interviewQuestion: InterviewQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppFonts()
        applicationInfoUI()
        setUpViewUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpViewUI() {
        contentView.layer.cornerRadius = AppRoundedViews.cornerRadius
        scrollView.layer.cornerRadius = AppRoundedViews.cornerRadius
        contentView.backgroundColor = AppColors.systemBackgroundColor
        scrollView.backgroundColor = AppColors.systemBackgroundColor
        infoIconImageView.tintColor = AppColors.primaryPurpleColor
    }
    
    private func setUpAppFonts() {
        promptLabel.font = AppFonts.boldFont
        promptLabel.textColor = AppColors.primaryBlackColor
        
        descriptionLabel.textColor = AppColors.primaryBlackColor
        
        instructionsLabel.font = AppFonts.secondaryFont
        instructionsLabel.textColor = AppColors.darkGrayHighlightColor
        
        signatureLabel.textColor = AppColors.primaryBlackColor
        
        dismissButton.setImage(AppButtonIcons.xmarkIcon, for: .normal)
        dismissButton.tintColor = AppColors.secondaryPurpleColor
    }
    
    private func applicationInfoUI() {
        switch enterFrom {
        case .jobHistory:
            promptLabel.text = "Your complete job history"
            descriptionLabel.text = "Most resumes require a minimum of three previous job experiences. Depending on the position you're applying to, you may want to edit your resume to reflect the job requirements.\nYou can now keep track of your entire job history and reference this app when updating your resume!"
            instructionsLabel.text = "Tap on ➕ icon on the top right, fill out the job history info\nConnect STAR Stories from your collection and attach any references directly from your contacts"
            signatureLabel.text = "Happy Job Hunting! \n \n - CV Team"
        case .starStories:
            promptLabel.text = "Understanding the STAR method"
            descriptionLabel.text = "The STAR method allows you to respond to interview questions with real examples to prove to the interviewer that you possess the right skills and experience for the job. STAR stands for:\n\nSituation - describe a specific moment from a previous job that resulted in a postive outcome.\n\nTask - what task did you need to perform for the best outcome in the situation?\n\nAction - what actions did you take?\n\nResult - describe the results of the actions you took. It is important to focus on STAR stories that ended with positive results."
            instructionsLabel.text = "Tap on ➕ icon on the top right and enter a STAR Story in either a guided or free form format."
            signatureLabel.text = "Happy Job Hunting! \n \n - CV Team"
        case .interviewQuestionsMain:
            promptLabel.text = "Prepare for an interview by studying these common interview questions"
            descriptionLabel.text = "In this collection you can see a list of the most common interview questions.\nYou can add your answers or attach the appropriate STAR Stories.\nYou also have the ability to bookmark specific questions you would like to practice at home."
            instructionsLabel.text = "Tap on ➕ icon on the top right to add any additional interview questions not already provided on this list.\nTap on the filter button on the top left to display questions in a specific collection."
            signatureLabel.text = "Happy Job Hunting! \n \n - CV Team"
        case .interviewAnswer:
            promptLabel.text = "How to answer this question"
            descriptionLabel.text = "\(interviewQuestion?.suggestion ?? "")"
            instructionsLabel.text = ""
            signatureLabel.text = ""
        case .applicationsTracker:
            promptLabel.text = "Tracking your job applications!"
            descriptionLabel.text = "Keeping track of all the jobs you've applied to and the progess with them can get pretty messy, but is extremely necessary! \nClear up all those spreadsheets, keeping track of all your applications has never been easier."
            instructionsLabel.text = "Tap on ➕ icon on the top right, fill out the application info and update as you go!"
            signatureLabel.text = "Happy Job Hunting! \n \n - CV Team"
        }
        
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
