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
    static let bookmarkedQuestionsCollection = "bookmarkedQuestions"
    
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
   
    //MARK:- Bookmarked Questions SubCollection
    public func addQuestionToBookmarks(question: InterviewQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.bookmarkedQuestionsCollection).document(question.id).setData(["id": question.id, "question": question.question, "suggestion": question.suggestion ?? ""]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    public func fetchBookmarkedQuestions(completion: @escaping(Result<[InterviewQuestion], Error>) -> ()){
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.bookmarkedQuestionsCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let bookmarkedQuestions = snapshot.documents.map { InterviewQuestion($0.data()) }
                completion(.success(bookmarkedQuestions))
            }
        }
    }
    public func isQuestioninBookmarks(question: InterviewQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.bookmarkedQuestionsCollection).whereField("id", isEqualTo: question.id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let count = snapshot.documents.count
                if count > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
    public func removeQuestionFromBookmarks(question: InterviewQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.bookmarkedQuestionsCollection).document(question.id).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    internal let db = Firestore.firestore()
}


