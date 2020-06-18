//
//  ArrayExt.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }

}
