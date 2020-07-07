//
//  ApplicationInfo.swift
//  Capstone
//
//  Created by Tsering Lama on 6/12/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

class ApplicationInfo {
    class func getVersionBuildNumber() -> String {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
            else {
                fatalError("no version info")
        }
        return "\(version)(\(build))"
    }
    
    class func getAppName() -> String {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
            fatalError("what? no app name")
        }
        return appName
    }
}

