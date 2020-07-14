//
//  InterviewData.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct Interview {
    var id: String
    var interviewDate: Timestamp?
    var thankYouSent: Bool
    var notes: String?
}
extension Interview {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "No ID"
        self.interviewDate = dictionary["interviewDate"] as? Timestamp ?? nil
        self.thankYouSent = dictionary["thankYouSent"] as? Bool ?? false
        self.notes = dictionary["notes"] as? String? ?? nil
    }
}
