//
//  UserDatabaseServices.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
    
    public func createDatabaseUser(authDataResult: AuthDataResult, completion: @escaping (Result<Bool, Error>)-> ()) {
        
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.userCollection).document(authDataResult.user.uid).setData(["email": email, "createdDate": Timestamp(date: Date()), "id": authDataResult.user.uid, "firstTimeLogin": true]) { error in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
            
        }
    }
    
    // Get data associated with a user
    public func fetchUserData(completion: @escaping (Result<User, Error>)-> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        let documentRef = db.collection(DatabaseService.userCollection).document(userID)
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data().map { User($0) }
                completion(.success(userData ?? User(createdDate: Date(), email: "N/N", firstTimeLogin: false, id: "")))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    public func updateUserFirstTimeLogin(firstTimeLogin: Bool, completion: @escaping (Result<Bool, Error>)-> ()) {
           guard let user = Auth.auth().currentUser else { return }
           let userID = user.uid
           db.collection(DatabaseService.userCollection).document(userID).updateData(["firstTimeLogin": firstTimeLogin]) { (error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(true))
               }
           }
           
       }
    
}
