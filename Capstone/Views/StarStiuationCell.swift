//
//  StarStiuationCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StarStiuationCell: UICollectionViewCell {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var numberOfQuestions: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    
    public func configureCell(starSituation: StarSituation) {
//        jobTitleLabel.text = starSituation.userJob.title
//        numberOfQuestions.text = "Answers \(starSituation.interviewQuestions.count) questions"
        situationLabel.text = starSituation.situation
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        //TODO: segues to StarStoryEntryVC
        //TODO: create delegate
    }
}
