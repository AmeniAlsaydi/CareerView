//
//  ProfileCells.swift
//  Capstone
//
//  Created by Gregory Keeley on 7/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MessageUI

struct ProfileCells {
    let title: String
    let images: UIImage
    let viewController: UIViewController
    static func loadProfileCells() -> [ProfileCells] {
        return [
            ProfileCells(title: profileCellType.account.rawValue, images: UIImage(systemName: "person.fill")!, viewController: AccountViewController(nibName: "AccountViewControllerXib", bundle: nil)),
            ProfileCells(title: profileCellType.settings.rawValue, images: UIImage(systemName: "gear")!, viewController: SettingsViewController(nibName: "SettingsViewControllerXib", bundle: nil)),
            ProfileCells(title: profileCellType.about.rawValue, images: UIImage(systemName: "info.circle")!, viewController: AboutThisAppViewController(nibName: "AboutThisAppViewControllerXib", bundle: nil)),
            ProfileCells(title: profileCellType.faq.rawValue, images: UIImage(systemName: "questionmark.circle.fill")!, viewController: FAQViewController(nibName: "FAQViewControllerXib", bundle: nil)),
            ProfileCells(title: profileCellType.contact.rawValue, images: UIImage(systemName: "bubble.middle.bottom")!, viewController: MFMailComposeViewController())
        ]
    }
    public enum profileCellType: String {
        case account = "Account"
        case settings = "Settings"
        case about = "About This App"
        case faq = "FAQ"
        case contact = "Contact Us"
    }
}
