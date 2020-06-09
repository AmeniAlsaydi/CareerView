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
    

    
    public func addStarSituationToUserJob(situation: StarSituation, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        guard let jobID = situation.userJobID else {
            completion(.success(false))
            return
        }
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(jobID).updateData(["starSituationIDs": FieldValue.arrayUnion(["\(situation.id)"])]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // Function to update a star situation with a user job id if its selected to be be added to a list of starSituationIDs
    // takes in the current userjob (or just the id)
    // takes in a situation
    // updates the userJobID field wit the passed userjob id info
    // this would be called when a user job is created or updated
    
    public func updateStarSituationWithUserJobId(userJobID: String, starSitutationID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.starSituationsCollection).document(starSitutationID).updateData(["userJobID": userJobID]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    
    public func removeStarSituationFromAnswer(answerID: String, starSolutionID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).document(answerID).updateData(["starSituationIDs" : FieldValue.arrayRemove(["\(starSolutionID)"])]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    public func addStarSituationToAnswer(answerID: String, starSolutionID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).document(answerID).updateData(["starSituationIDs" : FieldValue.arrayUnion(["\(starSolutionID)"])]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    public func addAnswerToAnswersArray(answerID: String, answerString: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).document(answerID).updateData(["answers" : FieldValue.arrayUnion(["\(answerString)"])]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func removeAnswerFromAnswersArray(answerID: String, answerString: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).document(answerID).updateData(["answers" : FieldValue.arrayRemove(["\(answerString)"])]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}


