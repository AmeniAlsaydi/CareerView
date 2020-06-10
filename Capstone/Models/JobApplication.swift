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
    var id: String
    var companyName: String
    var positionTitle: String
    var positionURL: String
    var remoteStatus: Bool
    var location: GeoPoint //CLLocation?
    var notes: String
    var applicationDeadline: Timestamp
    var dateApplied: Timestamp
    // var interviews: [Interview] 
    var interested: Bool
    var didApply: Bool
    var currentlyInterviewing: Bool
    var receivedReply: Bool
    var receivedOffer: Bool
}


extension JobApplication {
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "No ID found"
        self.companyName = dictionary["companyName"] as? String ?? "Company name NA"
        self.positionTitle = dictionary["positionTitle"] as? String ?? "Position title is NA"
        self.positionURL = dictionary["positionURL"] as? String ?? "Position URL is NA"
        self.remoteStatus = dictionary["remoteStatus"] as? Bool ?? false
        self.location = dictionary["location"] as? GeoPoint ?? GeoPoint(latitude: 40.7128, longitude: 74.0060)
        self.notes = dictionary["notes"] as? String ?? "No notes"
        self.applicationDeadline = dictionary["applicationDeadline"] as? Timestamp ?? Timestamp(date: Date())
        self.dateApplied = dictionary["dateApplied"] as? Timestamp ?? Timestamp(date: Date())
        
        self.interested = dictionary["interested"] as? Bool ?? false
        self.didApply = dictionary["didApply"] as? Bool ?? false
        self.currentlyInterviewing = dictionary["currentlyInterviewing"] as? Bool ?? false
        self.receivedReply = dictionary["receivedReply"] as? Bool ?? false
        self.receivedOffer = dictionary["receivedOffer"] as? Bool ?? false
    }
}
