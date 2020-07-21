//
//  JobApplicationsDatabaseServices.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
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
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(application.id).setData(["id": application.id, "companyName": application.companyName, "positionTitle": application.positionTitle, "positionURL": application.positionURL as Any, "remoteStatus": application.remoteStatus, "city": application.city as Any, "notes": application.notes as Any, "applicationDeadline": application.applicationDeadline as Any, "dateApplied": application.dateApplied as Any, "interested": application.interested, "didApply": application.didApply, "currentlyInterviewing": application.currentlyInterviewing, "receivedReply": application.receivedReply, "receivedOffer": application.receivedOffer]) { (error) in
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
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(applicationID).collection(DatabaseService.interviewCollection).document(interview.id).setData(["id": interview.id, "interviewDate": interview.interviewDate as Any, "thankYouSent": interview.thankYouSent, "notes": interview.notes as Any]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func deleteJobApplication(applicationID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(applicationID).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func getApplicationInterview(applicationID: String, completion: @escaping(Result<[Interview], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.jobApplicationCollection).document(applicationID).collection(DatabaseService.interviewCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let interviews = snapshot.documents.map {Interview($0.data())}
                completion(.success(interviews))
            }
        }
    }
}
