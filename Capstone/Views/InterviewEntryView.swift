//
//  InterviewEntryView.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewEntryView: UIView {

    public lazy var label: UILabel = {
        let label = UILabel()
        label.text = "hello"
        label.backgroundColor = .green
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
        constrainLabel()
    }
    
    private func constrainLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
}
