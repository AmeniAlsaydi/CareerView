//
//  UIStyles.swift
//  Capstone
//
//  Created by casandra grullon on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import UIKit

class AppColors {
    static let colors = AppColors()
    private init() {}
    //MARK:- Style Guide: Purples should be reserved for features that need to stand out or tell the user something is clickable/ interactive. Examples: UIButtons, Progress Bar, etc.
    static let primaryPurpleColor: UIColor = #colorLiteral(red: 0.2280851007, green: 0, blue: 0.5494799614, alpha: 1)
    static let secondaryPurpleColor: UIColor = #colorLiteral(red: 0.4743034244, green: 0, blue: 1, alpha: 1)
    
    //MARK:- Style Guide: Reserve Black for important text, cell headers, and Navigation Bar items. Example: Interview Question Cell color view, Nav Bar buttons and titles, Job Title, etc.
    static let primaryBlackColor: UIColor = .black
    
    //MARK:- Style Guide: Grays are meant for secondary information, detail text, seperation lines
    static let lightGrayHighlightColor: UIColor = .systemGray3
    static let darkGrayHighlightColor: UIColor = .systemGray
    
    //MARK:- Style Guide: Only use white when text will be infront of a view that isn't using a system color. Every other case should be system background
    static let whiteTextColor: UIColor = .white
    static let systemBackgroundColor: UIColor = .systemBackground
    
    //gradient background colors
    private let gradientPink: UIColor = #colorLiteral(red: 0.8186734915, green: 0.5191187263, blue: 0.9447844625, alpha: 1)
    private let gradientBlue: UIColor = #colorLiteral(red: 0.08412662894, green: 0.08182061464, blue: 0.3485977948, alpha: 1)
    private let gradientPurple: UIColor = #colorLiteral(red: 0.33890149, green: 0.0695855394, blue: 0.6190637946, alpha: 1)
    
    public func gradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [gradientBlue.cgColor, gradientPurple.cgColor, gradientPink.cgColor]
        view.backgroundColor = .clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
