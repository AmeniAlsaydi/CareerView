//
//  IndicatorExt.swift
//  Capstone
//
//  Created by Tsering Lama on 6/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

extension UIViewController {
    func showIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = AppColors.primaryPurpleColor
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func removeIndicator() {
        activityIndicator.removeFromSuperview()
    }
}
