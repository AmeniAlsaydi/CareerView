//
//  BasicStarSituationCell.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/17/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol BasicSituationDelegate: AnyObject {
    func didPressMoreButton()
}

class BasicStarSituationCell: UICollectionViewCell {
    
    @IBOutlet weak var situationLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: BasicSituationDelegate?
    
    public func configureCell(_ starSitaution: StarSituation) {
        
        situationLabel.text = starSitaution.situation
    }
    
    
}
