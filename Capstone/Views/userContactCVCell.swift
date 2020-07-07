//
//  UserContactCVCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 5/31/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class UserContactCVCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    public func configureCell(contact: Contact) {
        nameLabel.text = (" \(contact.firstName) \(contact.lastName) ")
        nameLabel.textColor = AppColors.secondaryPurpleColor
    }
    
}
