//
//  FAQInfo.swift
//  Capstone
//
//  Created by Gregory Keeley on 7/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct FAQInfo {
    let title: String
    let description: String
    static func loadFAQs() -> [FAQInfo] {
        return [
            FAQInfo(title: "How am I supposed to use the job history feature?", description: "Job History is meant to a \"master resume\" of sorts by allowing you to keep track of your entire job history.\nYou can use your logged job history as reference when creating new resumes, applying to jobs, or simply keeping track of your career over time."),
            FAQInfo(title: "What is a STAR story?", description: "A STAR story is an example of how you should be answering behavioral interview questions. This method allows you to deliver a clear and impactful response to an interview question.\nThe general structure of the answer should follow: Situation, Task, Action, and Result."),
            FAQInfo(title: "Where does all of this info go?", description: "We keep a private, secure server on firebase for user data."),
            FAQInfo(title: "What if I don't want this info uploaded?", description: "We are working on an update to allow our users to store all of their data locally on their device.")
        ]
    }
}
