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
    public func configureCell(index: Int) {
        switch index {
        case 0:
            screenshotImageView.image = #imageLiteral(resourceName: "screenshot1")
        case 1:
            screenshotImageView.image = #imageLiteral(resourceName: "screenshot2")
        case 2:
            screenshotImageView.image = #imageLiteral(resourceName: "screenshot3")
        case 3:
            screenshotImageView.image = #imageLiteral(resourceName: "screenshot4")
        default:
            screenshotImageView.image = #imageLiteral(resourceName: "somethingwentwrong")
        }
    }
}
