//
//  Contact.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Contacts

class Contact {
    let firstName: String
    let lastName: String
    let workEmail: String
    var identifier: String?
    var storedContact: CNMutableContact?
    
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
    init(firstName: String, lastName: String, workEmail: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.workEmail = workEmail
    }
    static func defaultContacts() -> [Contact] {
        return [
            Contact(firstName: "Greg", lastName: "Keeley", workEmail: "Greg@greg.com"),
            Contact(firstName: "Meghan", lastName: "Calderone", workEmail: "Whatever@gmail.com"),
            Contact(firstName: "Earl", lastName: "Pearl", workEmail: "BeautifulBirdie@yahoo.com")
        ]
    }
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool{
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.workEmail == rhs.workEmail
    }
}
extension Contact {
    var contactValue: CNContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: workEmail as NSString)]
        if let phoneNumberField = phoneNumberField {
            contact.phoneNumbers.append(phoneNumberField)
        }
        return contact.copy() as! CNContact
    }
    convenience init?(contact: CNContact) {
        guard let email = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let workEmail = email.value as String
        self.init(firstName: firstName, lastName: lastName, workEmail: workEmail)
        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }
}
