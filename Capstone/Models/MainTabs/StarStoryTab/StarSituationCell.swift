//
//  StarStiuationCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

//MARK:- Protocols
protocol StarSituationCellDelegate: AnyObject {
    func editStarSituationPressed(starSituation: StarSituation, starSituationCell: StarSituationCell)
}

class StarSituationCell: UICollectionViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var cellFooterView: UIView!
    //MARK:- Variables
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
        self.situationLabel.sizeToFit()
        setupAppUI()
    }
    private func setupAppUI(){
        self.backgroundColor = AppColors.systemBackgroundColor
        situationLabel.textColor = AppColors.primaryBlackColor
        editButton.setImage(AppButtonIcons.optionsIcon, for: .normal)
        editButton.tintColor = AppColors.secondaryPurpleColor
        cellFooterView.backgroundColor = AppColors.primaryPurpleColor
    }
    public func configureCell(starSituation: StarSituation) {
        editButton.addTarget(self, action: #selector(contextButtonPressed(_:)), for: .touchUpInside)
        if starSituation.task == "" || starSituation.action == "" || starSituation.result == "" {
            situationLabel.text = starSituation.situation
        } else {
            situationLabel.text = """
            Situation: \(starSituation.situation)
            Task: \(starSituation.task ?? "")
            Action: \(starSituation.action ?? "")
            Result: \(starSituation.result ?? "")
            """
            stylelizeText()
        }
        starSituationForDelegate = starSituation
    }
    @objc private func contextButtonPressed(_ sender: UIButton) {
        delegate?.editStarSituationPressed(starSituation: starSituationForDelegate!, starSituationCell: self)
    }
    private func stylelizeText() {
        let str = NSString(string: situationLabel.text!)
        let situationStrRange = str.range(of: "Situation:")
        let taskStrRange = str.range(of: "Task:")
        let actionStrRange = str.range(of: "Action:")
        let resultStrRange = str.range(of: "Result:")
        let font = UIFont(name: "Avenir-Medium", size: 20)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font!,
                                                         NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         NSAttributedString.Key.underlineColor: AppColors.primaryPurpleColor
        ]
        let attrString = NSMutableAttributedString(string: str as String, attributes: nil)
        attrString.addAttributes(attributes, range: situationStrRange)
        attrString.addAttributes(attributes, range: taskStrRange)
        attrString.addAttributes(attributes, range: actionStrRange)
        attrString.addAttributes(attributes, range: resultStrRange)
        situationLabel.attributedText = attrString
    }
}
