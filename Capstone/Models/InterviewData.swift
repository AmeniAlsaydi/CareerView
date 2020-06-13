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
    var interviewDate: Timestamp
    var thankYouSent: Bool
    // var followUpSent: Bool -> we need to discuss what this means
    var notes: String?
}

// do we want notes for each interview ?
