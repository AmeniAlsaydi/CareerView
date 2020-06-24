//
//  AnsweredQuestion.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/2/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct AnsweredQuestion { // FIXME: Should we rename this to InterviewAnswer ???
    var id: String
    var question: String
    var answers: [String]
    var starSituationIDs: [String]
}

extension AnsweredQuestion {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "no id for answered question"
        self.question = dictionary["question"] as? String ?? "no question found"
        self.answers = dictionary["answers"] as? [String] ?? ["no answers found"]
        self.starSituationIDs = dictionary["starSituationIDs"] as? [String] ?? ["no star situation IDs found"]
    }
}
