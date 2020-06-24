//
//  ApplicationDetailView.swift
//  Capstone
//
//  Created by Tsering Lama on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ApplicationDetailView: UIView {
    
    public lazy var interviewDateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semiBoldSmall
        return label
    }()
    
    public lazy var thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you note sent"
        label.font = AppFonts.primaryFont
        return label
    }()
    public lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = AppFonts.primaryFont
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var thankYouButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square")
        button.tintColor = .systemPurple
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = AppRoundedViews.cornerRadius
        backgroundColor = AppColors.complimentaryBackgroundColor
    }
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        constrainInterviewLabel()
        constrainThankYouLabel()
        constrainThankyouButton()
        constrainNotesLabel()
    }
    
    private func constrainInterviewLabel() {
        addSubview(interviewDateLabel)
        interviewDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            interviewDateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            interviewDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            interviewDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func constrainThankYouLabel() {
        addSubview(thankYouLabel)
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouLabel.topAnchor.constraint(equalTo: interviewDateLabel.bottomAnchor, constant: 10),
            thankYouLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    private func constrainThankyouButton() {
        addSubview(thankYouButton)
        thankYouButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouButton.widthAnchor.constraint(equalToConstant: 44),
            thankYouButton.topAnchor.constraint(equalTo: interviewDateLabel.bottomAnchor, constant: 10),
            thankYouButton.leadingAnchor.constraint(equalTo: thankYouLabel.trailingAnchor, constant: -40),
            thankYouButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func constrainNotesLabel() {
        addSubview(notesLabel)
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notesLabel.topAnchor.constraint(equalTo: thankYouLabel.bottomAnchor, constant: 10),
            notesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            notesLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
}



