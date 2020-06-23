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
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppFonts()
        applicationInfoUI()
        setUpViewUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpViewUI() {
        contentView.layer.cornerRadius = AppRoundedViews.cornerRadius
        scrollView.layer.cornerRadius = AppRoundedViews.cornerRadius
        
        contentView.backgroundColor = .tertiarySystemBackground
        scrollView.backgroundColor = .tertiarySystemBackground
    }
    
    private func setUpAppFonts() {
        promptLabel.font = AppFonts.boldFont
        promptLabel.textColor = AppColors.primaryBlackColor
        
        descriptionLabel.textColor = AppColors.primaryBlackColor
        
        instructionsLabel.font = AppFonts.secondaryFont
        instructionsLabel.textColor = AppColors.darkGrayHighlightColor
        
        signatureLabel.textColor = AppColors.primaryBlackColor
        
        dismissButton.setImage(AppButtonIcons.xmarkIcon, for: .normal)
        dismissButton.tintColor = AppColors.darkGrayHighlightColor
    }
    
    private func applicationInfoUI() {
        promptLabel.text = "Tracking your job applications!"
        descriptionLabel.text = "Keeping track of all the jobs you've applied to and the progess with them can get pretty messy, but is extremely necessary! \nClear up all those spreadsheets, keeping track of all your applications has never been easier."
        instructionsLabel.text = "Tep on ➕ icon on the top right, fill out the application info and update as you go!"
        signatureLabel.text = "Happy Job Hunting! \n \n - CV Team"
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
