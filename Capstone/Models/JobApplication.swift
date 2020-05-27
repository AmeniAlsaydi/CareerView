//
//  Application.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/21/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import Firebase

struct JobApplication {
    var companyName: String
    var positionTitle: String
    var positionURL: String
    var remoteStatus: Bool
    var location: GeoPoint //CLLocation?
    var notes: String
    var applicationDeadline: Timestamp
    var dateApplied: Timestamp
    var interviews: [Interview]
    var interested: Bool
    var didApply: Bool
    var currentlyInterviewing: Bool
    var receivedReply: Bool
    var receivedOffer: Bool
    
    
}
