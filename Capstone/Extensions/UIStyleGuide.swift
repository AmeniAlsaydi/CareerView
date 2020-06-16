//
//  UIStyles.swift
//  Capstone
//
//  Created by casandra grullon on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import UIKit

class UIStyleGuide {
    static let shared = UIStyleGuide()
    //static let appColors: AppColors
    private init() {}
}
class AppColors {
    static let colors = AppColors()
    private init() {}
    //MARK:- Style Guide: Purples should be reserved for features that need to stand out or tell the user something is clickable/ interactive. Examples: UIButtons, Progress Bar, etc.
    static let primaryPurpleColor: UIColor = #colorLiteral(red: 0.3141366243, green: 0.1664823294, blue: 0.6806778312, alpha: 1)
    static let secondaryPurpleColor: UIColor = #colorLiteral(red: 0.7428715825, green: 0.2606383562, blue: 1, alpha: 1)
    
    //MARK:- Style Guide: Reserve Black for important text, cell headers, and Navigation Bar items. Example: Interview Question Cell color view, Nav Bar buttons and titles, Job Title, etc.
    static let primaryBlackColor: UIColor = .black
    
    //MARK:- Style Guide: Grays are meant for secondary information, detail text, seperation lines
    static let lightGrayHighlightColor: UIColor = .systemGray3
    static let darkGrayHighlightColor: UIColor = .systemGray
    
    //MARK:- Style Guide: Only use white when text will be infront of a view that isn't using a system color. Every other case should be system background
    static let whiteTextColor: UIColor = .white
    static let systemBackgroundColor: UIColor = .systemBackground
    
    //gradient background colors
    private let gradientPink: UIColor = #colorLiteral(red: 0.9988244176, green: 0.2330017388, blue: 0.6751695871, alpha: 1)
    private let gradientBlue: UIColor = #colorLiteral(red: 0.105688177, green: 0.3018850684, blue: 0.7567492127, alpha: 1)
    private let gradientPurple: UIColor = #colorLiteral(red: 0.4692288041, green: 0.2948487699, blue: 0.6268667579, alpha: 1)
    
    public func gradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [gradientPink.cgColor, gradientPurple.cgColor, gradientBlue.cgColor]
        view.backgroundColor = .clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
