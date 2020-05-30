//
//  CapstoneTests.swift
//  CapstoneTests
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest

@testable import Capstone

class CapstoneTests: XCTestCase {
    
    func testFirebase() {
        let expected = "hello"
        let exp = XCTestExpectation(description: "test found")
        
        DatabaseService.shared.testFirebase { (results) in
            switch results {
                case(.failure(let error)):
                    print("error in test: \(error.localizedDescription)")
                case(.success(let tests)):
                    XCTAssertEqual(expected, tests.first?.test)
                    exp.fulfill()
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchUserJobs() {
        let expectedCount = 1 // current user has one job 
        let exp = XCTestExpectation(description: "user jobs found")
        
        DatabaseService.shared.fetchUserJobs { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                print("error fetching user jobs: \(error.localizedDescription)")
            case(.success(let userJobs)):
                XCTAssertEqual(expectedCount, userJobs.count)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
}
