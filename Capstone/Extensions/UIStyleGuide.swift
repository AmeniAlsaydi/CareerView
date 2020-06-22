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
    
    //MARK:- Style Guide: Purples should be reserved for features that need to stand out or tell the user something is clickable/ interactive. Examples: UIButtons, Progress Bar, etc.
    static let primaryPurpleColor: UIColor = #colorLiteral(red: 0.2280851007, green: 0, blue: 0.5494799614, alpha: 1)
    static let secondaryPurpleColor: UIColor = #colorLiteral(red: 0.6090013385, green: 0.1283935905, blue: 0.9983350635, alpha: 1)
    
    //MARK:- Style Guide: Reserve Black for important text, cell headers, and Navigation Bar items. Example: Interview Question Cell color view, Nav Bar buttons and titles, Job Title, etc.
    static let primaryBlackColor: UIColor = .label
    
    //MARK:- Style Guide: Grays are meant for secondary information, detail text, seperation lines
    static let lightGrayHighlightColor: UIColor = .systemGray3
    static let darkGrayHighlightColor: UIColor = .systemGray
    
    //MARK:- Style Guide: Only use white when text will be infront of a view that isn't using a system color. Every other case should be system background
    static let whiteTextColor: UIColor = .white
    static let systemBackgroundColor: UIColor = .systemBackground
    //MARK:- Reserve for collection view/ table view background color
    static let complimentaryBackgroundColor: UIColor = .secondarySystemBackground
    
    //gradient background colors
    private let gradientPink: UIColor = #colorLiteral(red: 0.8805331588, green: 0.7443125248, blue: 0.9330717921, alpha: 1)
    private let gradientBlue: UIColor = #colorLiteral(red: 0.08412662894, green: 0.08182061464, blue: 0.3485977948, alpha: 1)
    private let gradientPurple: UIColor = #colorLiteral(red: 0.557056725, green: 0.1121184751, blue: 1, alpha: 1)
    
    private init() {}
    
    //MARK:- reserve gradients for small ui views only
    public func gradientBackground(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [gradientBlue.cgColor, gradientPurple.cgColor, gradientPink.cgColor]
        view.backgroundColor = .clear
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
class AppFonts {
    static let fonts = AppFonts()
    
    static let primaryFont = UIFont(name: "Avenir-Regular", size: 17)
    static let boldFont = UIFont(name: "Avenir-Heavy", size: 25)
    static let semiBoldLarge = UIFont(name: "Avenir-Medium", size: 20)
    static let semiBoldSmall = UIFont(name: "Avenir-Medium", size: 17)
    static let secondaryFont = UIFont(name: "Helvetica", size: 17)
    static let subtitleFont = UIFont(name: "AvenirNext-Bold", size: 14)
    private init() {}
}
class AppButtonIcons {
    static let buttons = AppButtonIcons()
    
    static let plusIcon = UIImage(systemName: "plus")
    static let optionsIcon = UIImage(systemName: "ellipsis")
    static let filterIcon = UIImage(systemName: "slider.horizontal.3")
    static let bookmarkIcon = UIImage(systemName: "bookmark")
    static let bookmarkFillIcon = UIImage(systemName: "bookmark.fill")
    static let checkmarkIcon = UIImage(systemName: "checkmark")
    static let xmarkIcon = UIImage(systemName: "xmark")
    static let infoIcon = UIImage(systemName: "info.circle")
    static let backArrowIcon = UIImage(systemName: "arrow.left")
    static let emptySquareIcon = UIImage(systemName: "square")
    static let squareCheckmarkIcon = UIImage(systemName: "checkmark.square")
    static let squareCheckmarkFillIcon = UIImage(systemName: "checkmark.square.fill")
    private let navBarBackButton = UIImage(systemName: "arrow.left")
    
    private init() {}
    public func navBarBackButtonItem(navigationItem: UINavigationItem) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        //backItem.image = navBarBackButton
        navigationItem.backBarButtonItem = backItem
    }
}
class AppRoundedViews {
    static let cornerRadius: CGFloat = 8
}
