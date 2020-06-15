//
//  JobHistoryExpandableCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobHistoryExpandableCell: FoldingCell {
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var jobTitleLabel2: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var companyNameLabel2: UILabel!
    @IBOutlet weak var jobDescriptionLabel2: UILabel!
    @IBOutlet weak var responsibilityOne: UILabel!
    @IBOutlet weak var responsibilityTwo: UILabel!
    @IBOutlet weak var responsibilityThree: UILabel!
    @IBOutlet weak var starSituationButton: UIButton!
    @IBOutlet weak var interviewButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    func updateGeneralInfo(userJob: UserJob) {
        jobTitleLabel.text = userJob.title
        companyNameLabel.text = "Company: \(userJob.companyName)"
        jobDescriptionLabel.text = userJob.description
        dateLabel.text = "\(userJob.beginDate.dateValue().dateString()) - \(userJob.endDate.dateValue().dateString()) "
        jobTitleLabel2.text = userJob.title
        companyNameLabel2.text = "Company: \(userJob.companyName)"
        jobDescriptionLabel2.text = userJob.description
        dateLabel2.text = "\(userJob.beginDate.dateValue().dateString()) - \(userJob.endDate.dateValue().dateString()) "
        
        if userJob.responsibilities.count == 3 {
            responsibilityOne.text = userJob.responsibilities[0]
            responsibilityTwo.text = userJob.responsibilities[1]
            responsibilityThree.text = userJob.responsibilities[2]
        }
        
        if userJob.responsibilities.count == 2 {
            responsibilityOne.text = userJob.responsibilities[0]
            responsibilityTwo.text = userJob.responsibilities[1]
        }
        
        if userJob.responsibilities.count == 1 {
            responsibilityOne.text = userJob.responsibilities[0]
        }
        
        if userJob.responsibilities.count == 0 {
            responsibilityOne.textAlignment = .center
            responsibilityOne.text = "No responsibility listed for this job"
        }
        
        starSituationButton.setTitle(userJob.starSituationIDs.count.description, for: .normal)
        interviewButton.setTitle(userJob.interviewQuestionIDs.count.description, for: .normal)
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

extension Date {
    public func dateString(_ format: String = "MM/dd/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // self the Date object itself
        // dateValue().dateString()
        return dateFormatter.string(from: self)
    }
}
