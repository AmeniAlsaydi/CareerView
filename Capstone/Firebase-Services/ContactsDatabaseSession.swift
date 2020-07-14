//
//  ContactsDatabaseSession.swift
//  Capstone
//
//  Created by casandra grullon on 7/14/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension DatabaseService {
    public func addContactsToUserJob(userJobId: String, contact: Contact, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        // Note: This only uploads first and last name, and ID. Goal is to load the local contact based on this info, without uploading too much to firebase
        db.collection(DatabaseService.userCollection).document(userID).collection(DatabaseService.userJobCollection).document(userJobId).collection(DatabaseService.contactsCollection).document(contact.id).setData(["id": contact.id, "firstName": contact.firstName, "lastName": contact.lastName, "email": contact.workEmail]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
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
    public func deleteContactFromJob(userJobId: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.contactsCollection).document(userJobId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
