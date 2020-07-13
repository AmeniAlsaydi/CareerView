//
//  HairlineView.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class HairlineView: UIView {
    override func awakeFromNib() {
        //guard let backgroundColor = self.backgroundColor?.cgColor else { return }
        self.layer.borderColor = AppColors.primaryBlackColor.cgColor
        self.layer.borderWidth = (1.0 / UIScreen.main.scale) / 2;
        self.backgroundColor = UIColor.clear
    }
}
