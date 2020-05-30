//
//  UserJob.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct UserJob {
    var title: String
    var companyName: String
    var beginDate: Timestamp
    var endDate: Timestamp
    var currentEmployer: Bool
    var description: String
    var responsibilities: [String]
    var starSituationIDs: [String]
    var interviewQuestionIDs: [String]
    // var contactIDs: [String] - removed because no longer needed
    // var contacts: [Contact] - removed because it's a sub collection
    
}

extension UserJob {
    init(_ dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? "Title NA"
        self.companyName = dictionary["companyName"] as? String ?? "Company name NA "
        self.beginDate = dictionary["beginDate"] as? Timestamp ?? Timestamp(date: Date())
        self.endDate = dictionary["endDate"] as? Timestamp ?? Timestamp(date: Date())
        self.currentEmployer = dictionary["currentEmployer"] as? Bool ?? true
        self.description = dictionary["description"] as? String ?? "Job description NA"
        self.responsibilities = dictionary["responsibilities"] as? [String] ?? ["Responsibilities NA"]
        self.starSituationIDs = dictionary["starSituationIDs"] as? [String] ?? ["Star situations NA"]
        self.interviewQuestionIDs = dictionary["interviewQuestionIDs"] as? [String] ?? ["Interview questions NA"]
    }
}
