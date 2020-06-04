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
    @IBOutlet weak var bkgdview: UIView!
    public func configureCell(contact: Contact) {
        bkgdview.layer.masksToBounds = true
        bkgdview.layer.cornerRadius = 4
        nameLabel.text = (" \(contact.firstName) \(contact.lastName) ")
    }
}
