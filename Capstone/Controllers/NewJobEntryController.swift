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
    
    private var activeTextField = UITextField()
    
    public var starSituationIDsToAdd = [String]() {
        didSet {
            print(starSituationIDsToAdd.count) // just to test we get back stars
            // reload star story collection
            //self.starSituationsCollectionView.reloadData()
        }
    }
    private func configureContactsCollectionView() {
        self.contactsCollectionView.delegate = self
        self.contactsCollectionView.dataSource = self
        self.contactsCollectionView.isUserInteractionEnabled = true
        self.contactsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.contactsCollectionView.register(UINib(nibName: "UserContactCVCell", bundle: nil), forCellWithReuseIdentifier: "userContactCell")
    }
    
    private var contacts = [CNContact]()
    private var userContacts = [Contact]() {
        didSet {
            print(userContacts.count) // just to test we get contacts back
            // should reload the contactsCollection
            self.contactsCollectionView.reloadData()
        }
    }
    
    private var isCurrentEmployer = false {
        didSet {
            if isCurrentEmployer {
                currentEmployerButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                // animate endDateTextField height to zero
                // set end date to todays date
            } else {
                currentEmployerButton.setImage(UIImage(systemName: "square"), for: .normal)
                
                // animate endDateTextField height to original height
            }
        }
    }
    
    private let datePicker = UIDatePicker()
    
    private var beginDate: Date?
    private var endDate: Date?
    public var editingJob = false
    
    public var userJob: UserJob?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleAllTextFields()
        createDatePicker()
        setUpDelegateForTextFields()
        configureContactsCollectionView()
    }
    
    private func setUpDelegateForTextFields() {
        beginDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    
    
    // FIXME: this function is used if both forms - make it reusable
    private func createDatePicker() {
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
        
        if activeTextField == beginDateTextField {
            beginDateTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
            beginDate = datePicker.date
        } else if activeTextField == endDateTextField {
            endDateTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
            endDate = datePicker.date
        }
        
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
        
        // create use job object
        
        // check mandatory fields
        
        var userJobId = UUID().uuidString
        
        if editingJob {
            userJobId = userJob?.id ?? UUID().uuidString
        }
        
        // guard for mandatory fields
        
        guard let jobTitle = positionTitleTextField.text,
            !jobTitle.isEmpty,
            let companyName = companyNameTextField.text,
            !companyName.isEmpty,
            let description = descriptionTextField.text,
            !description.isEmpty else {
              self.showAlert(title: "Missing fields", message: "Check all mandatory fields.")
            return
        }
        
        let location = locationTextField.text
        
        guard let beginDate = beginDate else {
            self.showAlert(title: "Missing fields", message: "Please enter the date you began this position.")
            return
        }
        
        guard let responsibilty1 = responsibility1TextField.text else {
            self.showAlert(title: "Responsibilities?", message: "Please enter at least one of ypur responsibilites at this position.")
            return
        }
        
        let beginTimeStamp = Timestamp(date: beginDate)
        var endTimeStamp: Timestamp? = nil
        
        if isCurrentEmployer {
            endTimeStamp = Timestamp(date: Date())
        } else if let endDate = endDate {
            endTimeStamp = Timestamp(date: endDate)
        }
        
        let userJobToSave = UserJob(id: userJobId, title: jobTitle, companyName: companyName, location: location ?? "", beginDate: beginTimeStamp, endDate: endTimeStamp!, currentEmployer: isCurrentEmployer, description: description, responsibilities: [responsibilty1], starSituationIDs: starSituationIDsToAdd, interviewQuestionIDs: [])
        
        DatabaseService.shared.addToUserJobs(userJob: userJobToSave, completion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to save job", message: error.localizedDescription)
                }
            case .success:
                // show alert and pop VC
                DispatchQueue.main.async {
                    if self?.editingJob ?? false {
                        self?.showAlert(title: "Job Updated!", message: "Success!")  { (alert) in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        self?.showAlert(title: "Job Saved", message: "Success!")  { (alert) in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        })
        
        // send contacts to contacts collection for user job
        if userContacts.count != 0 {
            for contact in userContacts {
                DatabaseService.shared.addContactsToUserJob(userJobId: userJobToSave.id, contact: contact, completion: { [weak self] (results) in
                    switch results {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error saving contact", message: error.localizedDescription)
                        }
                    case .success:
                        break
                    }
                })
            }
        }
        
        
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

extension NewJobEntryController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as! FloatingLabelInput
    }
}

//MARK:- CollectionView Extension
extension NewJobEntryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
}

extension NewJobEntryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contact = userContacts[indexPath.row]
        let contactViewController = CNContactViewController(forUnknownContact: contact.contactValue)
        navigationController?.pushViewController(contactViewController, animated: true)
    }
}

extension NewJobEntryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userContacts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userContactCell", for: indexPath) as? UserContactCVCell else {
            fatalError("failed to dequeue userContactCell")
        }
        cell.backgroundColor = .red
        let contact = userContacts[indexPath.row]
        cell.configureCell(contact: contact)
        return cell
    }
}
