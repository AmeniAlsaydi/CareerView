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
    
    
    override func layoutSubviews() {
        self.layer.borderWidth = 1
//        let purple = #colorLiteral(red: 0.305962503, green: 0.1264642179, blue: 0.6983457208, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 4
    }
    weak var delegate: BasicSituationDelegate?
    
    public func configureCell(_ starSitaution: StarSituation) {
        
        situationLabel.text = starSitaution.situation
    }
    
    
}
