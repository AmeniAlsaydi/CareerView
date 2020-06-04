//
//  ScreenshotCollectionViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var screenshotImageView: UIImageView!
    public func configureCell(screenshot: String) {
        screenshotImageView.layer.cornerRadius = 4
        screenshotImageView.layer.masksToBounds = true
        screenshotImageView.image = UIImage(named: screenshot)
    }
}
