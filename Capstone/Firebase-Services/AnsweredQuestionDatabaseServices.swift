//
//  AnsweredQuestionDatabaseServices.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/9/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension DatabaseService {
    
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
    
    
    // FIXME: the following returns an array of AnsweredQuestion, do we want to return just one (the first) ?
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
    
}
