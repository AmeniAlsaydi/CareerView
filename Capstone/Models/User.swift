//
//  User.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/2/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct User {
    let createdDate: Date
    let email: String
    let firstTimeLogin: Bool
    let id: String
}
extension User {
    init(_ dictionary: [String: Any]) {
        self.createdDate = dictionary["createdDate"] as? Date ?? Date()
        self.email = dictionary["email"] as? String ?? "No email"
        self.firstTimeLogin = dictionary["firstTimeLogin"] as? Bool ?? true
        self.id = dictionary["id"] as? String ?? "No ID available"
    }
}
