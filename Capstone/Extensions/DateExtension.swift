//
//  DateExtension.swift
//  Capstone
//
//  Created by Gregory Keeley on 7/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

extension Date {
    public func dateString(_ format: String = "MMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
