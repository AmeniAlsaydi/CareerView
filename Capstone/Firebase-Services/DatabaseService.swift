//
//  DatabaseService.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    public static let shared = DatabaseService()
    private init() {}

    static let userCollection = "users"
    static let userJobCollection = "userJobs"
    static let commonQuestionCollection = "commonInterviewQuestions"
    static let contactsCollection = "contacts"
    static let jobApplicationCollection = "jobApplications"
    static let interviewCollection = "interviews"
    static let customQuestionsCollection = "customInterviewQuestions"
    static let answeredQuestionsCollection = "answeredQuestions"
    static let starSituationsCollection = "starSituations"
    
    internal let db = Firestore.firestore()
    
    // TODO: create CRUD functions for interview data to application (is its own collection
     
    
}


