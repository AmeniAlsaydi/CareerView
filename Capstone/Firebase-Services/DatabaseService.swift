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
    
    private let db = Firestore.firestore()
    
    public func testFirebase(completion: @escaping (Result<[Job], Error>) -> ()) {
        
        db.collection(DatabaseService.testCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                
                let testJobs = snapshot.documents.map { Job($0.data())}
                completion(.success(testJobs))
            }
        }
    }
}
