//
//  UserPreferences.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/22/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct LaunchScreen {
    let title: String
    static func getLaunchScreens() -> [LaunchScreen] {
        return [LaunchScreen(title: DefaultLaunchScreen.jobHistory.rawValue),
                LaunchScreen(title: DefaultLaunchScreen.starStories.rawValue),
                LaunchScreen(title: DefaultLaunchScreen.interviewQuestions.rawValue),
                LaunchScreen(title: DefaultLaunchScreen.applicationTracker.rawValue)]
    }
}

