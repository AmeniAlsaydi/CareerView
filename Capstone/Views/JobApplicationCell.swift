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
    @IBOutlet weak var staticStatusLabel: UILabel!
    @IBOutlet weak var currentStatusIndicatorLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth * 0.95
        }
    }
    override func layoutSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 12
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // FIXME: understand public - private - internal
    public func configureCell(application: JobApplication) {
        
        positionLabel.text = application.positionTitle.capitalized
        companyNameLabel.text = ("@\(application.companyName.capitalized)")
        configureLabels()
        if let submittedDate = application.dateApplied?.dateValue().dateString("MMM d, yyyy") {
            submittedDateLabel.text = "Applied \(submittedDate)"
        } else {
            submittedDateLabel.text = "Not applied"
        }
        
        if application.receivedOffer {
            progressBar.progress = 1.0
            currentStatusIndicatorLabel.text = "Recieved Offer"
        } else if application.currentlyInterviewing {
            progressBar.progress = 0.8
            currentStatusIndicatorLabel.text = "Interviewing"
        } else if application.receivedReply {
            progressBar.progress = 0.6
            currentStatusIndicatorLabel.text = "Recieved Reply"
        } else if application.didApply {
            progressBar.progress = 0.4
            currentStatusIndicatorLabel.text = "Applied"
        } else if application.interested {
            progressBar.progress = 0.2
            currentStatusIndicatorLabel.text = "Interested"
        } else {
            progressBar.progress = 0.0
        }
        
    }
    private func configureLabels() {
        positionLabel.font = AppFonts.boldFont
        companyNameLabel.font = AppFonts.semiBoldSmall
        submittedDateLabel.font = AppFonts.secondaryFont
        staticStatusLabel.font = AppFonts.primaryFont
        currentStatusIndicatorLabel.font = AppFonts.primaryFont
        
        
        currentStatusIndicatorLabel.tintColor = AppColors.secondaryPurpleColor
    }
    
    
}
