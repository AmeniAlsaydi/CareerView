//
//  JobHistoryBasicCell.swift
//  Capstone
//
//  Created by casandra grullon on 5/29/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ContactCell: UICollectionViewCell {
    @IBOutlet weak var contactNameButton: UIButton!
    
    @IBAction func contactButtonPressed(_ sender: UIButton) {
        
    }
}

class JobHistoryBasicCell: UITableViewCell {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var responsibilitiesLabel1: UILabel!
    @IBOutlet weak var responsibilitiesLabel2: UILabel!
    @IBOutlet weak var responsibilitiesLabel3: UILabel!
    @IBOutlet weak var responsibilitiesLabel4: UILabel!
    @IBOutlet weak var responsibilitiesLabel5: UILabel!
    @IBOutlet weak var starSituationsButton: UIButton!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    @IBAction func starSituationButtonPressed(_ sender: UIButton) {
        //Segue to STAR Story VC
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        //Segue to JobEntry VC editing mode
    }
}
//TODO: make this cell resizing

