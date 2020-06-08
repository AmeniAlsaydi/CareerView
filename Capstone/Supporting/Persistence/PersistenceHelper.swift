//
//  PersistenceHelper.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/8/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation
import DataPersistence

enum DataPersistenceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodeError(Error)
    case deletingError(Error)
}
class PersistenceHelper {
    //TODO: Implement data persistence for local storage of user data (aka "offline mode")
}
