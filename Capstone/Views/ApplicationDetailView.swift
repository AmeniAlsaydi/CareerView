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
        label.text = "Hi"
        return label
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
    
    public func configureUI(interview: Interview) {
        interviewDateLabel.text = interview.interviewDate?.dateValue().dateString()
    }
    
}



