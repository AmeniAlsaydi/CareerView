//
//  StarStiuationCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol StarSituationCellDelegate: AnyObject {
    func editStarSituationPressed(starSituation: StarSituation, starSituationCell: StarSituationCell)
}

class StarSituationCell: UICollectionViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var cellFooterView: UIView!
    
    weak var delegate: StarSituationCellDelegate?
    private var starSituationForDelegate: StarSituation?
    public var starSituationIsSelected = false
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = AppRoundedViews.cornerRadius
        setupAppUI()
    }
    private func setupAppUI(){
        self.backgroundColor = AppColors.systemBackgroundColor
        situationLabel.font = AppFonts.semiBoldSmall
        situationLabel.textColor = AppColors.primaryBlackColor
        editButton.setImage(AppButtonIcons.optionsIcon, for: .normal)
        editButton.tintColor = AppColors.secondaryPurpleColor
        cellFooterView.backgroundColor = AppColors.primaryPurpleColor
    }
    public func configureCell(starSituation: StarSituation) {
        editButton.addTarget(self, action: #selector(contextButtonPressed(_:)), for: .touchUpInside)
        
        if let task = starSituation.task, let action = starSituation.action, let result = starSituation.result {
            situationLabel.text = """
            Situation: \(starSituation.situation)
            Task: \(task)
            Action: \(action)
            Result: \(result)
            """
        } else {
            situationLabel.text = starSituation.situation
        }
        
        starSituationForDelegate = starSituation
    }
    @objc private func contextButtonPressed(_ sender: UIButton) {
        delegate?.editStarSituationPressed(starSituation: starSituationForDelegate!, starSituationCell: self)
    }
    
}
