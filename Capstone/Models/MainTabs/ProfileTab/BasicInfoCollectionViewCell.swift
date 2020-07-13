//
//  BasicInfoCollectionViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class BasicInfoCollectionViewCell: UICollectionViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    //MARK:- PreferredLayoutAttributesFitting
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    //MARK:- ConfigureCell
    public func configureCell(faq: FAQInfo?, userInfo: UserInfo.userInfoSection?) {
        self.layer.cornerRadius = AppRoundedViews.cornerRadius
        self.layer.masksToBounds = true
        if faq != nil {
            titleLabel.text = faq?.title
            answerLabel.text = faq?.description
        } else if userInfo != nil {
            switch userInfo {
            case userInfo where userInfo?.rawValue == UserInfo.userInfoSection.email.rawValue:
                titleLabel.text = userInfo?.rawValue
                if let user = Auth.auth().currentUser {
                    answerLabel.text = user.email
                }
            case userInfo where userInfo?.rawValue == UserInfo.userInfoSection.jobApplicationCount.rawValue:
                titleLabel.text = userInfo?.rawValue
                DatabaseService.shared.fetchApplications { [weak self](result) in
                    switch result {
                    case .failure(let error):
                        print("error getting applications: \(error)")
                    case .success(let jobApplications):
                        DispatchQueue.main.async {
                            self?.answerLabel.text = String(jobApplications.count)
                        }
                    }
                }
            case userInfo where userInfo?.rawValue == UserInfo.userInfoSection.jobHistoryCount.rawValue:
                titleLabel.text = userInfo?.rawValue
                DatabaseService.shared.fetchUserJobs { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        print("error fetching user jobs\(error.localizedDescription)")
                    case .success(let userJobHistory):
                        DispatchQueue.main.async {
                            self?.answerLabel.text = String(userJobHistory.count)
                        }
                    }
                }
            case userInfo where userInfo?.rawValue == UserInfo.userInfoSection.starStoryCount.rawValue:
                titleLabel.text = userInfo?.rawValue
                DatabaseService.shared.fetchStarSituations { [weak self] (results) in
                    switch results {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("error fetching star situations\(error.localizedDescription)")
                        }
                    case .success(let starSituationsData):
                        DispatchQueue.main.async {
                            self?.answerLabel.text = String(starSituationsData.count)
                        }
                    }
                }
            default:
                titleLabel.text = "Error"
            }
        }
    }
}
