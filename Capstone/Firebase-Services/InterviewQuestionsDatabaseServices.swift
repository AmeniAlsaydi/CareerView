//
//  CommonInterviewQuestionsDatabaseServices.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
    
    //MARK:- Common Interview Questions
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
    //MARK:- Custom Interview Questions
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
    public func updateCustomQuestion(customQuestion: InterviewQuestion, completion: @escaping (Result<Bool,Error>)->() ) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.customQuestionsCollection).document(customQuestion.id).updateData(["question": customQuestion.question]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func deleteCustomQuestion(customQuestion: InterviewQuestion, completion: @escaping(Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.customQuestionsCollection).document(customQuestion.id).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
