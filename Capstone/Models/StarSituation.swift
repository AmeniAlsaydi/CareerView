//
//  StarSituation.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct StarSituation {
    var situation: String
    var task: String?
    var action: String?
    var result: String?
    var id: String
    var userJobID: String
    var interviewQuestionsIDs: [String]
}

extension StarSituation {
    init(_ dictionary: [String: Any]) {
        self.situation = dictionary["situation"] as? String ?? "Situation NA"
        self.task = dictionary["task"] as? String ?? nil
        self.action = dictionary["action"] as? String ?? nil
        self.result = dictionary["result"] as? String ?? nil
        self.id = dictionary["id"] as? String ?? "No ID found"
        self.userJobID = dictionary["userJobID"] as? String ?? "No userJob ID found"
        self.interviewQuestionsIDs = dictionary["interviewQuestionsIDs"] as? [String] ?? ["No interview questions ID found"]
    }
}
