//
//  JobApplicationCell.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobApplicationCell: UICollectionViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var submittedDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    
    override func layoutSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 12
    }
    
    
    // FIXME: understand public - private - internal
    public func configureCell(application: JobApplication) {
        
        positionLabel.text = application.positionTitle.capitalized
        companyNameLabel.text = application.companyName.capitalized
        if let submittedDate = application.dateApplied?.dateValue().dateString("MMM d, yyyy") {
            submittedDateLabel.text = "Date Applied: \(submittedDate)"
        } else {
            submittedDateLabel.text = "Date Applied: N/A"
        }
        
        if application.receivedOffer {
            progressBar.progress = 1.0
            statusLabel.text = "Recieved Offer 💵 🥳"
        } else if application.currentlyInterviewing {
            progressBar.progress = 0.8
            statusLabel.text = "Interviewing 🗣"
        } else if application.receivedReply {
            progressBar.progress = 0.6
            statusLabel.text = "Recieved Reply 📨"
        } else if application.didApply {
            progressBar.progress = 0.4
            statusLabel.text = "Applied 📝"
        } else if application.interested {
            progressBar.progress = 0.2
            statusLabel.text = "Interested 👀"
        } else {
            progressBar.progress = 0.0
        }
        
    }
    
    
    
}
