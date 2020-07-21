//
//  BookmarkQuestionsDatabaseServices.swift
//  Capstone
//
//  Created by casandra grullon on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
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
    public func isQuestionInBookmarks(question: InterviewQuestion, completion: @escaping (Result<Bool, Error>) -> ()) {
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
}
