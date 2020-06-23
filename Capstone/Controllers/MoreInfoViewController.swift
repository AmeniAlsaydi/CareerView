//
//  MoreInfoViewController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppFonts()
        
    }
    
    
    private func setUpAppFonts() {
        promptLabel.font = AppFonts.boldFont
        promptLabel.textColor = AppColors.primaryBlackColor
        
        descriptionLabel.textColor = AppColors.primaryBlackColor
        
        instructionsLabel.font = AppFonts.secondaryFont
        instructionsLabel.textColor = AppColors.darkGrayHighlightColor
        
        signatureLabel.textColor = AppColors.primaryBlackColor
    }

}
