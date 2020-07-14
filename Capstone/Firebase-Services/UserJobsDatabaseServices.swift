//
//  UserJobsDatabaseServices.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
    // fetch current users job
    public func fetchUserJobs(completion: @escaping (Result<[UserJob], Error>)->()) {
        guard let user = Auth.auth().currentUser else { return }
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
        // Note: This only uploads first and last name, and ID. Goal is to load the local contact based on this info, without uploading too much to firebase
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).collection(DatabaseService.contactsCollection).document(contact.id).setData(["id": contact.id, "firstName": contact.firstName, "lastName": contact.lastName]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        //        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).collection(DatabaseService.contactsCollection).document(contact.id).setData(["id": contact.id, "firstName": contact.firstName, "lastName": contact.lastName, "email": contact.workEmail, "phoneNumber": contact.phoneNumberField as Any]) { error in
        //              if let error = error {
        //                  completion(.failure(error))
        //              } else {
        //                  completion(.success(true))
        //              }
        //          }
    }
    public func fetchContactsForJob(userJobId: String, completion: @escaping (Result<[Contact], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).collection(DatabaseService.contactsCollection).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let contacts = snapshot.documents.map { Contact($0.data())}
                completion(.success(contacts))
            }
        })
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
}
