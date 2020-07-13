//
//  UserInfo.swift
//  Capstone
//
//  Created by Gregory Keeley on 7/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct UserInfo: Equatable {
    let primaryEmail: String = userInfoSection.email.rawValue
    let jobHistoryCount: String = userInfoSection.jobHistoryCount.rawValue
    let starStoryCount: String = userInfoSection.starStoryCount.rawValue
    let jobApplicationCount: String = userInfoSection.jobApplicationCount.rawValue
    static func setupUserSectionArray() -> [userInfoSection] {
        return [userInfoSection.email, userInfoSection.jobApplicationCount, userInfoSection.jobHistoryCount, userInfoSection.starStoryCount]
    }
    public enum userInfoSection: String {
        case email = "Email Address"
        case jobHistoryCount = "Job History Count"
        case starStoryCount = "STAR Story Count"
        case jobApplicationCount = "Job Applications Being Tracked"
    }
}
