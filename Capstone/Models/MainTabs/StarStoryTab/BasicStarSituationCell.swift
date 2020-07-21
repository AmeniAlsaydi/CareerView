//
//  BasicStarSituationCell.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/17/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
//MARK:- Protocols
protocol BasicSituationDelegate: AnyObject {
    func didPressMoreButton(starSituation: StarSituation, starSituationCell: BasicStarSituationCell)
}

class BasicStarSituationCell: UICollectionViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    //MARK:- LayoutSubviews
    override func layoutSubviews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 4
        moreButton.tintColor = AppColors.secondaryPurpleColor
    }
    //MARK:- Variables
    weak var delegate: BasicSituationDelegate?
    private var currentStarSituation: StarSituation?
    //MARK:- Functions
    public func configureCell(_ starSitaution: StarSituation) {
        currentStarSituation = starSitaution
        situationLabel.text = starSitaution.situation
    }
    //MARK:- IBAction
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        delegate?.didPressMoreButton(starSituation: currentStarSituation!, starSituationCell: self)
    }
}
