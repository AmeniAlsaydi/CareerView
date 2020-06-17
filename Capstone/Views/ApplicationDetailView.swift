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
        return label
    }()
    
    public lazy var thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you note sent?"
        return label
    }()
    
    public lazy var thankYouButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square")
        button.tintColor = .systemPurple
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureInterviewLabel()
        constrainThankYouLabel()
        constainThankyouButton()
    }
    
    private func configureInterviewLabel() {
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
            thankYouLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func constainThankyouButton() {
        addSubview(thankYouButton)
        thankYouButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouButton.widthAnchor.constraint(equalToConstant: 44),
            thankYouButton.topAnchor.constraint(equalTo: interviewDateLabel.bottomAnchor, constant: 10),
            thankYouButton.leadingAnchor.constraint(equalTo: thankYouLabel.trailingAnchor, constant: -40),
            thankYouButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
}



