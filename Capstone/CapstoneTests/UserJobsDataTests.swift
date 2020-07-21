//
//  UserJobsDataTests.swift
//  CapstoneTests
//
//  Created by Amy Alsaydi on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift


@testable import Capstone

class UserJobsDataTests: XCTestCase {
    
       func testAddingToUserJobs() {
           let exp = XCTestExpectation(description: "user job added")
           let id = UUID().uuidString
           
           let userJob = UserJob(["id": id, "title": "title", "companyName": "companyName", "beginDate": Timestamp(date: Date()), "endDate": Timestamp(date: Date()), "currentEmployer": true, "description": "description", "responsibilities": ["id1", "id2"], "starSituationIDs": ["id1", "id2"], "interviewQuestionIDs": ["id1", "id2"]])
           
           DatabaseService.shared.addToUserJobs(userJob: userJob) { (result) in
               exp.fulfill()
               
               switch result {
               case(.failure(let error)):
                   XCTFail("error adding to user jobs: \(error.localizedDescription)")
               case(.success(let result)):
                   XCTAssertTrue(result)
               }
               
           }
           wait(for:[exp], timeout: 5.0)
       }
       
       
       func testRemovingUserJob() {
           let exp = XCTestExpectation(description: "user job removed")
           let testid = "testid" // add new id here to test another delete
           
           DatabaseService.shared.removeUserJob(userJobId: testid) { (result) in
               exp.fulfill()
               switch result {
               case(.failure(let error)):
                   XCTFail("error deleting to user jobs: \(error.localizedDescription)")
               //print("error deleting to user jobs: \(error.localizedDescription)")
               case(.success(let result)):
                   XCTAssertTrue(result)
               }
           }
           
           wait(for:[exp], timeout: 5.0)
       }
    
    func testFetchUserJobs() {
        let expectedCount = 17 // current user has 17 jobs

        let exp = XCTestExpectation(description: "user jobs found")
        
        DatabaseService.shared.fetchUserJobs { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching user jobs: \(error.localizedDescription)")
            case(.success(let userJobs)):
                XCTAssertEqual(expectedCount, userJobs.count)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }


}
