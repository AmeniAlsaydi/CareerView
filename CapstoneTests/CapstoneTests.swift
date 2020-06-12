//
//  CapstoneTests.swift
//  CapstoneTests
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift


@testable import Capstone

class CapstoneTests: XCTestCase {
    
   
    func testFetchingInterviewQuestions() {
        let expectedCount = 6 // during this test there were 6 common interview questions on database
        let exp = XCTestExpectation(description: "interview questions found")
        
        DatabaseService.shared.fetchCommonInterviewQuestions { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching interview questions: \(error.localizedDescription)")
            case(.success(let questions)):
                XCTAssertEqual(expectedCount, questions.count)
                
            }
        }
        
        wait(for:[exp], timeout: 5.0)
    }
    
    func testAddingContactsToUserJob() {
        
        let exp = XCTestExpectation(description: "added contact to user job")
        let userJobId = "27A8243C-47D5-4D8F-A0C0-835373828977"
        let contact = Contact(firstName: "tom", lastName: "tommy", email: "tom.com", id: "12345")
        
        DatabaseService.shared.addContactsToUserJob(userJobId: userJobId, contact: contact) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding contact to user job: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchingJobApplication() {
        let exp = XCTestExpectation(description: "job applications found")
        let expectedApplicationCount = 0 // change number to current users number of application
        
        DatabaseService.shared.fetchApplications { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching job application: \(error.localizedDescription)")
            case(.success(let applications)):
                XCTAssertEqual(applications.count, expectedApplicationCount)
            }
        }
        
        wait(for:[exp], timeout: 5.0)
        
    }
    
    func testAddingInterview() {
        let exp = XCTestExpectation(description: "interview data added job applications")
        let applicationID = "BPSDevKLkdCxf1iqAkTl"
        
        let interview = Interview(id: "11111", interviewDate: Timestamp(date: Date()), thankYouSent: false, notes: "no notes")
        
        DatabaseService.shared.addInterviewToApplication(applicationID: applicationID, interview: interview) { (result) in
            exp.fulfill()
            
            switch result {
            case(.failure(let error)):
                XCTFail("error adding interview data to application: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    
    func testAddingApplication() {
        let exp = XCTestExpectation(description: "added job applications")
        
        let application = JobApplication(id: "121212", companyName: "company x", positionTitle: "boss", positionURL: "url", remoteStatus: true, location: GeoPoint(latitude: 0, longitude: 0), notes: "no notes", applicationDeadline: Timestamp(date: Date()), dateApplied: Timestamp(date: Date()), interested: true, didApply: true, currentlyInterviewing: true, receivedReply: true, receivedOffer: true)
        
        
        DatabaseService.shared.addApplication(application: application) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding interview data to application: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchingCustomQuestions() {
        let exp = XCTestExpectation(description: "custom interview questions found")
        let expected = "1001"
        
        DatabaseService.shared.fetchCustomInterviewQuestions { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding interview data to application: \(error.localizedDescription)")
            case(.success(let questions)):
                XCTAssertEqual(expected, questions.first?.id)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    
    func testAddingCustomQuestion() {
        // arrange
        let exp = XCTestExpectation(description: "custom interview question was add")
        let id = UUID().uuidString
        let customQ = InterviewQuestion(question: "testing add a custom question?", suggestion: nil, id: id)
        
        // act
        DatabaseService.shared.addCustomInterviewQuestion(customQuestion: customQ) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding custom interview question: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testAddingAnsweredQuestion() {
        
        let exp = XCTestExpectation(description: "answered q was added to collection")
        let id = UUID().uuidString
        let answerdQ = AnsweredQuestion(id: id, question: "What are your greatest weaknesses?", answers: ["trick question"], starSituationIDs: ["id1", "id2"])
        
        DatabaseService.shared.addToAnsweredQuestions(answeredQuestion: answerdQ) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding answered question: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchingAnsweredQuestions() {
        let exp = XCTestExpectation(description: "answered questions found")
        let question = "What are your greatest weaknesses?"
        let expectedAnswer = "trick question"
        
        DatabaseService.shared.fetchAnsweredQuestions(questionString: question) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching answered questions: \(error.localizedDescription)")
            case(.success(let answeredQuestions)):
                let firstAnswer = answeredQuestions.first?.answers.first
                XCTAssertEqual(firstAnswer, expectedAnswer)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testAddingStarSituation() {
        
        let exp = XCTestExpectation(description: "situation was added")
        let id = UUID().uuidString
        let starSituation = StarSituation(situation: "situation test", task: nil, action: "action test", result: "result test", id: id, userJobID: "12345", interviewQuestionsIDs: [])
        
        DatabaseService.shared.addToStarSituations(starSituation: starSituation) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error adding a situation: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testFetchingStarSituations() {
        let exp = XCTestExpectation(description: "situations found")
        let expectedSituation = "situation test"
        let expectedTask: String? = nil
        
        DatabaseService.shared.fetchStarSituations { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error fetching situations: \(error.localizedDescription)")
            case(.success(let situations)):
                XCTAssertEqual(situations.first?.situation, expectedSituation)
                XCTAssertEqual(situations.first?.task, expectedTask)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testRemovingStarSituationFromUserJob() {
        
        let exp = XCTestExpectation(description: "situation removed")
        let situation = StarSituation(situation: "", task: "", action: "", result: "", id: "id2", userJobID: "FE96D016-6C7D-439A-B71F-50215DDF017C", interviewQuestionsIDs: [])
        
        DatabaseService.shared.removeStarSituationfromUserJob(situation: situation) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error removing a situation from user job: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
        
    }
    
    func testAddingStarSituationToUserJob() {
        let exp = XCTestExpectation(description: "situation added")
        let situation = StarSituation(situation: "", task: "", action: "", result: "", id: "id2", userJobID: "FE96D016-6C7D-439A-B71F-50215DDF017C", interviewQuestionsIDs: [])
        
        DatabaseService.shared.addStarSituationToUserJob(situation: situation) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error removing a situation from user job: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testUpdatingStarSituationWithJobID() {
        
        let exp = XCTestExpectation(description: "user job id added to star situation")
        let userJobID = "1111111"
        let starSituationID = "0E4E4981-6286-461D-AF72-450BFD905F52"
        
        DatabaseService.shared.updateStarSituationWithUserJobId(userJobID: userJobID, starSitutationID: starSituationID) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error updating a situation user job id: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
        
    }
    
    func testRemovingStarSituationFromAnswer() {
        let exp = XCTestExpectation(description: "situation was removed")
        let situationID = "id1"
        let answerID = "C8465E3A-1E63-4F44-8C49-EEDD7D96C221"
        
        DatabaseService.shared.removeStarSituationFromAnswer(answerID: answerID, starSolutionID: situationID) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error updating a situation user job id: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    
    func testAddingStarSituationFromAnswer() {
        let exp = XCTestExpectation(description: "situation was removed")
        let situationID = "id1"
        let answerID = "C8465E3A-1E63-4F44-8C49-EEDD7D96C221"
        
        DatabaseService.shared.addStarSituationToAnswer(answerID: answerID, starSolutionID: situationID) { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error updating a situation user job id: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testAddingAnswerToAnswersArray() {
        let exp = XCTestExpectation(description: "situation was added")
        let answerID = "C8465E3A-1E63-4F44-8C49-EEDD7D96C221"
        
        DatabaseService.shared.addAnswerToAnswersArray(answerID: answerID, answerString: "this is my answer - testing add an answer") { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error updating a situation user job id: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }

    func testRemovingAnswerToAnswersArray() {
        let exp = XCTestExpectation(description: "situation was remove")
        let answerID = "C8465E3A-1E63-4F44-8C49-EEDD7D96C221"
        
        DatabaseService.shared.removeAnswerFromAnswersArray(answerID: answerID, answerString: "trick question") { (result) in
            exp.fulfill()
            switch result {
            case(.failure(let error)):
                XCTFail("error updating a situation user job id: \(error.localizedDescription)")
            case(.success(let result)):
                XCTAssertTrue(result)
            }
        }
        wait(for:[exp], timeout: 5.0)
    }
    
    func testCreateWorkout() {
        // arrange
        let workoutTimeStamp = Timestamp(date: Date())
        let workoutType = "Running"
        let workoutTitle = "Foreset Park Run"
        let workoutDict: [String: Any ] = ["workoutTimeStamp": workoutTimeStamp,
                                           "workoutType": workoutType,
                                           "workoutTitle": workoutTitle
        ]
        let exp = XCTestExpectation(description: "workout created")
        // act
        Firestore.firestore().collection("workouts").document(UUID().uuidString).setData(workoutDict) { (error) in
            // assert
            exp.fulfill()
            if let error = error {
                XCTFail("failed to create workout with error: \(error.localizedDescription)")
            }
            XCTAssert(true)
        }
        wait(for: [exp], timeout: 3.0)
    }
    
}


