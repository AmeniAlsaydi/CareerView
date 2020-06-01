//
//  InterviewQuestion.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct InterviewQuestion {
    var question: String
    var suggestion: String
    var id: String
}

extension InterviewQuestion {
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "No ID"
        self.suggestion = dictionary["suggestion"] as? String ?? "Suggestion NA"
        self.question = dictionary["question"] as? String ?? "Question NA"
    }
}
