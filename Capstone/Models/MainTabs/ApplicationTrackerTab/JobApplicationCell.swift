//
//  JobApplicationCell.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobApplicationCell: UICollectionViewCell {
    //MARK:- IBOutkets
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var submittedDateLabel: UILabel!
    @IBOutlet weak var currentStatusIndicatorLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    //MARK:- Variables
    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth * 0.95
        }
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
    override func layoutSubviews() {
        self.layer.cornerRadius = AppRoundedViews.cornerRadius
        setupCellUI()
    }
    //MARK:- Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar.layer.sublayers?.removeAll()
    }
    public func configureCell(application: JobApplication) {
        positionLabel.text = application.positionTitle.capitalized
        companyNameLabel.text = ("@\(application.companyName.capitalized)")
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
    private func setupCellUI(){
        self.backgroundColor = AppColors.systemBackgroundColor
        positionLabel.textColor = AppColors.primaryBlackColor
        companyNameLabel.textColor = AppColors.primaryBlackColor
        submittedDateLabel.textColor = AppColors.primaryBlackColor
        currentStatusIndicatorLabel.textColor = AppColors.secondaryPurpleColor
        positionLabel.font = AppFonts.semiBoldLarge
        companyNameLabel.font = AppFonts.semiBoldSmall
        submittedDateLabel.font = AppFonts.primaryFont
        currentStatusIndicatorLabel.font = AppFonts.primaryFont
    }
}
