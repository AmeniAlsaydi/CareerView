//
//  SettingCell.swift
//  Capstone
//
//  Created by Tsering Lama on 6/11/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var settingsName: UILabel!
    
    public func configureCell(setting: Settings) {
        settingsImage.image = setting.images
        settingsName.text = setting.tabs
    }
}
