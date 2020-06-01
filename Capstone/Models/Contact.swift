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
    let email: String
    var id: String
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
    var phoneNumber: String
    
    init(firstName: String, lastName: String, email: String, id: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        self.phoneNumber = phoneNumberField?.value.stringValue ?? "123" // FIXME: determine best way to get phone number
        
    }
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool{
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email
    }
}
extension Contact {
    var contactValue: CNContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: email as NSString)]
        if let phoneNumberField = phoneNumberField {
            contact.phoneNumbers.append(phoneNumberField)
        }
        return contact.copy() as! CNContact
    }
    convenience init?(contact: CNContact) {
        guard let firstEmail = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let email = firstEmail.value as String
        let id = UUID().uuidString
        self.init(firstName: firstName, lastName: lastName, email: email, id: id)
        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }
}


