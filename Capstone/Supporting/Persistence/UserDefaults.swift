//
//  UserDefaults.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/8/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

enum GuidedStarSitutionInput: String {
    case guided = "guided"
    case freeForm = "freeForm"
}
enum ShowUserStarInputOption: String {
    case on = "on"
    case off = "off"
}
enum DefaultLaunchScreen: String {
    case jobHistory = "Job History"
    case starStories = "STAR Stories"
    case interviewQuestions = "Interview Questions"
    case applicationTracker = "Application Tracker"
}
struct UserPreferenceKey {
    static let GuidedInputPreference = "GuidedInputPreference"
    static let ShowUserStarInputOption = "ShowUserStarInputOption"
    static let defaultLaunchScreen = "DefaultLaunchScreen"
}

class UserPreference {
    
    private init() {}
    private let standard = UserDefaults.standard
    static let shared = UserPreference()
    
    func updateDefaultLaunchScreen(with preference: String) {
        print("default launch screen set to: \(preference)")
        standard.set(preference, forKey: UserPreferenceKey.defaultLaunchScreen)
    }
    func getDefaultLaunchScreen() -> DefaultLaunchScreen? {
        guard let preference = standard.object(forKey: UserPreferenceKey.defaultLaunchScreen) as? String else {
            return nil
        }
        return DefaultLaunchScreen(rawValue: preference)
    }
    // Note: Guided or freeform preference
    func updateShowGuidedStarSituationInput(with preference: GuidedStarSitutionInput) {
        standard.set(preference.rawValue, forKey: UserPreferenceKey.GuidedInputPreference)
    }
    func getGuidedSituationInputPreference() -> GuidedStarSitutionInput? {
        guard let preference = standard.object(forKey: UserPreferenceKey.GuidedInputPreference) as? String else {
            return nil
        }
        return GuidedStarSitutionInput(rawValue: preference)
    }
    // Note: This will determine whether or not to show the option for guided or freeform
    func updatePreferenceShowUserInputOption(with preference: ShowUserStarInputOption) {
        standard.set(preference.rawValue, forKey: UserPreferenceKey.ShowUserStarInputOption)
    }
    func getPreferenceShowInputOption() -> ShowUserStarInputOption? {
        guard let preference = standard.object(forKey: UserPreferenceKey.ShowUserStarInputOption) as? String else {
            return nil
        }
        return ShowUserStarInputOption(rawValue: preference)
    }
}
