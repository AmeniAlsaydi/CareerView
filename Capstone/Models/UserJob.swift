//
//  UserJob.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct UserJob {
    var title: String
    var companyName: String
    var beginDate: Date
    var endDate: Date // might still be working there?
    var currentEmployer: Bool
    var description: String
    var responsibilities: [String]
    var starSituations: [StarSituation]
    var InterviewQuestions: [InterviewQuestion]
    //var coWorkerReference: [Contact]
    
}
