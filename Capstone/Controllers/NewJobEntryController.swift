//
//  NewJobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI

class NewJobEntryController: UIViewController {
    
    @IBOutlet weak var positionTitleTextField: FloatingLabelInput!
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var descriptionTextField: FloatingLabelInput!
    @IBOutlet weak var beginDateTextField: FloatingLabelInput!
    @IBOutlet weak var endDateTextField: FloatingLabelInput!
    @IBOutlet weak var responsibility1TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility2TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility3TextField: FloatingLabelInput!
    @IBOutlet weak var starSituationsCollectionView: UICollectionView!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    @IBOutlet weak var currentEmployerButton: UIButton!
    
    public var starSituationIDsToAdd = [String]() {
        didSet {
            print(starSituationIDsToAdd.count) // just to test we get back stars
            // reload star story collection
            //self.starSituationsCollectionView.reloadData()
        }
    }
    
    private var contacts = [CNContact]()
    private var userContacts = [Contact]() {
        didSet {
            print(userContacts.count) // just to test we get contacts back
            // should reload the contactsCollection
            //self.contactsCollectionView.reloadData()
        }
    }
    
    private var isCurrentEmployer = false {
        didSet {
            if isCurrentEmployer {
                currentEmployerButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                currentEmployerButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleAllTextFields()
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        // assign toolbar
        beginDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputAccessoryView = toolbar
        
        // assign date picker to text feild
        beginDateTextField.inputView = datePicker
        endDateTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        
        beginDateTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
        // need to handle end date 
        // date = datePicker.date
        self.view.endEditing(true)
    }
    
    private func configureNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveJobButtonPressed(_:)))
    }
    
    private func styleAllTextFields() {
        
        let textFields = [companyNameTextField, positionTitleTextField, locationTextField, descriptionTextField, beginDateTextField, endDateTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
        
        let _ = textFields.map { $0?.styleTextField()}
        
    }
    
    
    @objc private func saveJobButtonPressed(_ sender: UIBarButtonItem) {
        // create new job and add to datebase
        print("create new job and add to datebase")
    }
    
    
    @IBAction func currentEmployerButtonPressed(_ sender: UIButton) {
        isCurrentEmployer.toggle()
        
    }
    
    @IBAction func addStarSituationButtonPressed(_ sender: UIButton) {
        // display star situations
        let starStoryVC = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        starStoryVC.starSituationIDs = starSituationIDsToAdd
        starStoryVC.isAddingToUserJob = true
        starStoryVC.delegate = self
        present(UINavigationController(rootViewController: starStoryVC), animated: true)
        // allow them to select
        // add ids to an array (used in the created of the job)
        // display them on the collection view
    }
    
    @IBAction func addContactsButtonPressed(_ sender: UIButton) {
        // display contacts controller
        
        //Note: This will check for access to contact permission and if not determined, ask again
        // If the user denied permission, they will directed to settings where they can give permission to the app
        // TODO: Determine, do we want to ask permission again in the app if they denied? Or show alert?
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authorizationStatus == .notDetermined {
            store.requestAccess(for: .contacts) { [weak self] didAuthorize, error in
                if didAuthorize {
                    self?.retrieveContacts()
                }
            }
        }  else if authorizationStatus == .denied {
            showAlert(title: "Access to contacts has been denied", message: "Please go to settings -> CareerView if you would like to give permission to contacts")
        } else if authorizationStatus == .authorized {
            retrieveContacts()
        }
        
        // add contacts to an array (will be used to add to the contacts collection)
        // display them on the collection view
    }
    
    private func retrieveContacts() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    
    
}

//MARK:- CNContactPickerDelegate
extension NewJobEntryController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        self.contacts = contacts
        let newContacts = contacts.compactMap { Contact(contact: $0) }
        for contact in newContacts {
            self.contacts.append(contact.contactValue)
            if !userContacts.contains(contact) {
                self.userContacts.append(contact)
            }
        }
    }
}


extension NewJobEntryController: StarStoryMainControllerDelegate {
    func starStoryMainViewControllerDismissed(starSituations: [String]) {
        starSituationIDsToAdd = starSituations
    }
}
