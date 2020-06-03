//
//  ScreenshotCollectionViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var screenshotImageView: UIImageView!
    public func configureCell(screenshot: String) {
        screenshotImageView.image = UIImage(named: screenshot)
    }
}
