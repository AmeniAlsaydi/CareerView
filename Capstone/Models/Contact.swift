//
//  Contact.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class Contact {
    let firstName: String
    let lastName: String
    let workEmail: String
    var id: String
    var storedContact: CNMutableContact?
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
//    var phoneNumber: String
    
    init(_ dictionary: [String: Any]) {
        self.firstName = dictionary["firstName"] as? String ?? "No First Name"
        self.lastName = dictionary["lastName"] as? String ?? "No Last Name"
        self.workEmail = dictionary["email"] as? String ?? "No Email address"
        self.id = dictionary["id"] as? String ?? "No ID"
//        self.phoneNumber = dictionary["phoneNumber"] as? String ?? "No Phone Number"
    }
//    init(firstName: String, lastName: String, email: String, id: String) {
//        self.firstName = firstName
//        self.lastName = lastName
//        self.workEmail = email
//        self.id = id
//    }
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
        guard let firstEmail = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let workEmail = firstEmail.value as String
        let id = UUID().uuidString
        let dictionary: [String: Any] = ["firstName": firstName, "lastName": lastName, "workEmail": workEmail, "id": id]
        self.init(dictionary)
        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }
    
    internal func presentContactViewController(contact: Contact, rootViewController: UIViewController) {
        let contactViewController = UINavigationController(rootViewController: CNContactViewController(forUnknownContact: contact.contactValue))
    }
}


