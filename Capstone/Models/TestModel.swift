//
//  Job.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/21/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct TestModel {
    var test: String
}

extension TestModel {
    init(_ dictionary: [String: Any]) {
        self.test = dictionary["test"] as? String ?? "no material type"
    }
}
