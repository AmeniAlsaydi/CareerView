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
    
    static let testCollection = "tester"
    static let userCollection = "users"
    static let userJobCollection = "userJobs"
    static let commonQuestionCollection = "commonInterviewQuestions"
    static let contactsCollection = "contacts"
    static let jobApplicationCollection = "jobApplications"
    static let interviewCollection = "interviews"
    static let customQuestionsCollection = "customInterviewQuestions"
    static let answeredQuestionsCollection = "answeredQuestions"
    static let starSituationsCollection = "starSituations"
    
    private let db = Firestore.firestore()
    
    public func testFirebase(completion: @escaping (Result<[TestModel], Error>) -> ()) {
        
        db.collection(DatabaseService.testCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                
                let testJobs = snapshot.documents.map { TestModel($0.data())}
                completion(.success(testJobs))
            }
        }
    }
    
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>)-> ()) {
        
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email": email, "createdDate": Timestamp(date: Date()), "id": authDataResult.user.uid]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        }
    }
    
    // fetch current users job
    public func fetchUserJobs(completion: @escaping (Result<[UserJob], Error>)->()) {
        guard let user = Auth.auth().currentUser else { return}
        
        let userID = user.uid // use this to test -> "LOT6p7nkxfM69CCtjB41"
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let userJobs = snapshot.documents.map { UserJob($0.data())}
                completion(.success(userJobs))
            }
        }
    }
    
    // add job to curret users job list
    public func addToUserJobs(userJob: UserJob, completion: @escaping (Result<Bool, Error>) -> ()){
        guard let user = Auth.auth().currentUser else {return}
        
        let userID = user.uid
               
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJob.id).setData(["id": userJob.id, "title": userJob.title, "companyName": userJob.companyName, "beginDate": userJob.beginDate, "endDate": userJob.endDate, "currentEmployer": userJob.currentEmployer, "description": userJob.description, "responsibilities": userJob.responsibilities, "starSituationIDs": userJob.starSituationIDs, "interviewQuestionIDs": userJob.interviewQuestionIDs]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func addContactsToUserJob(userJobId: String, contact: Contact, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).collection(DatabaseService.contactsCollection).document(contact.id).setData(["id": contact.id, "firstName": contact.firstName, "lastName": contact.lastName, "email": contact.email, "phoneNumber": contact.phoneNumber]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
        }
      
    public func removeUserJob(userJobId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).delete { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func fetchCommonInterviewQuestions(completion: @escaping (Result<[InterviewQuestion],Error>) -> ()) {
        
        db.collection(DatabaseService.commonQuestionCollection).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let questions = snapshot.documents.map { InterviewQuestion($0.data())}
                completion(.success(questions))
            }
        }
    }
    
    public func fetchApplications(completion: @escaping (Result<[JobApplication], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let applications = snapshot.documents.map {JobApplication($0.data())}
                completion(.success(applications))
            }
        }
    }
    
    public func addApplication(application: JobApplication, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(application.id).setData(["id": application.id, "companyName": application.companyName, "positionTitle": application.positionTitle, "positionURL": application.positionTitle, "remoteStatus": application.remoteStatus, "location": application.location, "notes": application.notes, "applicationDeadline": application.applicationDeadline, "dateApplied": application.dateApplied, "interested": application.interested, "didApply": application.didApply, "currentlyInterviewing": application.currentlyInterviewing, "receivedReply": application.receivedReply, "receivedOffer": application.receivedOffer]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
        
    }
    
    public func addInterviewToApplication(applicationID: String, interview: Interview, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(applicationID).collection(DatabaseService.interviewCollection).document(interview.id).setData(["id": interview.id, "interviewDate": interview.interviewDate, "thankYouSent": interview.thankYouSent, "followUpSent": interview.followUpSent, "notes": interview.notes]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    public func fetchCustomInterviewQuestions(completion: @escaping (Result<[InterviewQuestion], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.customQuestionsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let questions = snapshot.documents.map {InterviewQuestion($0.data())}
                completion(.success(questions))
            }
        }
        
    }
    
    public func addCustomInterviewQuestion(customQuestion: InterviewQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.customQuestionsCollection).document(customQuestion.id).setData(["id": customQuestion.id, "question": customQuestion.question]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // to get interview question answers we will filter answeredQuestions collection using the question string
    
    public func addToAnsweredQuestions(answeredQuestion: AnsweredQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).document(answeredQuestion.id).setData(["id": answeredQuestion.id, "question": answeredQuestion.question, "answers": answeredQuestion.answers, "starSituationIDs": answeredQuestion.starSituationIDs ]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    

    public func fetchAnsweredQuestions(questionString: String, completion: @escaping (Result<[AnsweredQuestion], Error>)->()) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.answeredQuestionsCollection).whereField("question", isEqualTo: questionString).getDocuments { (snapShot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapShot = snapShot {
                let answeredQuestions = snapShot.documents.map { AnsweredQuestion($0.data())}
                completion(.success(answeredQuestions))
            }
        }
    }
    
    public func addToStarSituations(starSituation: StarSituation, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.starSituationsCollection).document(starSituation.id).setData(["id": starSituation.id, "situation": starSituation.situation, "task": starSituation.task as Any, "action": starSituation.action as Any, "result": starSituation.result as Any, "userJobID": starSituation.userJobID, "interviewQuestionsIDs": starSituation.interviewQuestionsIDs]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
  
    }
}

