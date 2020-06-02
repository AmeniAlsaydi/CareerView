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
    @IBOutlet weak var editButton2: UIButton!
    
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
