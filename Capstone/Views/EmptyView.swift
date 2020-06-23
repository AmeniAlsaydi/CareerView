//
//  EmptyView.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    private lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppColors.darkGrayHighlightColor
        return iv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.boldFont
        label.textColor = AppColors.darkGrayHighlightColor
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.secondaryFont
        label.textColor = AppColors.lightGrayHighlightColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    init(title: String, message: String, imageName: String) {
        super.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        msgLabel.text = message
        image.image = UIImage(systemName: imageName)
        
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        constrainImage()
        setUptitleConstraints()
        setupMsgConstaints()
    }
    private func constrainImage() {
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -20),
            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    private func setUptitleConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    private func setupMsgConstaints() {
        addSubview(msgLabel)
        msgLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            msgLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            msgLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            msgLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}

