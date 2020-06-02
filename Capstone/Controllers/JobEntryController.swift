//
//  JobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI


class JobEntryController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    //MARK:- Cells
    @IBOutlet var jobTitleCell: UITableViewCell!
    @IBOutlet var companyTitleCell: UITableViewCell!
    @IBOutlet var currentEmployerCell: UITableViewCell!
    @IBOutlet var beginEmploymentDateCell: UITableViewCell!
    @IBOutlet var endEmploymentCell: UITableViewCell!
    @IBOutlet var locationCell: UITableViewCell!
    @IBOutlet var descriptionCell: UITableViewCell!
    @IBOutlet var mainResponsiblityCell: UITableViewCell!
    @IBOutlet var responsiblity2Cell: UITableViewCell!
    @IBOutlet var responsiblity3Cell: UITableViewCell!
    @IBOutlet var addStarSituationCell: UITableViewCell!
    @IBOutlet var userContactsCVCell: UITableViewCell!
    //MARK:- Buttons
    @IBOutlet weak var currentlyEmployedButton: UIButton!
    @IBOutlet weak var addResponsibilityButton: UIButton!
    @IBOutlet weak var addStarSituationButton: UIButton!
    @IBOutlet weak var deleteResponsibiltyButton1: UIButton!
    @IBOutlet weak var deleteResponsibiltyButton2: UIButton!
    //MARK:- TextFields
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var beginDateMonthTextField: UITextField!
    @IBOutlet weak var beginDateYearTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var endDateMonthTextField: UITextField!
    @IBOutlet weak var endDateYearTextField: UITextField!
    @IBOutlet weak var responsibility1TextField: UITextField!
    @IBOutlet weak var responsibility2TextField: UITextField!
    @IBOutlet weak var responsibility3TextField: UITextField!
    
    @IBOutlet weak var userContactsCollectionView: UICollectionView!
    
    //MARK:- Variables
    public var userJob: UserJob?
    private var testUserJob = UserJob(id: UUID().uuidString, title: "Retail Employee", companyName: "Sonos", location: "NY, NY", beginDate: Timestamp(date: Date(timeIntervalSince1970: 1464783949)), endDate: Timestamp(date: Date(timeIntervalSince1970: 1509539149)), currentEmployer: true, description: "Assisted customers with making purchase decisions", responsibilities: ["Operated POS for transactions","Helped customers troubleshoot products"], starSituationIDs: [], interviewQuestionIDs: [])
    
    public var editingJob = false
    private var currentlyEmployed: Bool = false {
        didSet {
            print(currentlyEmployed)
            configureCurrentlyEmployedButton(currentlyEmployed)
        }
    }
    private var responsibilityCells = [String]() {
        didSet {
            // Disable add responsibility button
            tableView.reloadData()
            if responsibilityCells.count == 3 {
                addResponsibilityButton.isEnabled = false
            } else {
                addResponsibilityButton.isEnabled = true
            }
        }
    }
    private var responsibilities = [String]()
    private var contacts = [CNContact]()
    private var userContacts = [Contact]() {
        didSet {
            self.tableView.reloadData()
            self.userContactsCollectionView.reloadData()
        }
    }
    // IDs from starSituations
    var linkedStarSituations = [String]()
    // IDs from interview questions
    var linkedInterviewQuestions = [String]()
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTextFields()
        setupNavigationBar()
        listenForKeyboardEvents()
        loadUserJob()
        addInputAccessoryForTextFields(textFields: [jobTitleTextField, companyNameTextField, beginDateYearTextField, beginDateMonthTextField, endDateYearTextField, endDateMonthTextField, locationTextField, descriptionTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField], dismissable: true, previousNextable: true)
    }
    private func configureView() {
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        self.userContactsCollectionView.delegate = self
        self.userContactsCollectionView.dataSource = self
        self.userContactsCollectionView.isUserInteractionEnabled = true
        self.userContactsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.userContactsCollectionView.register(UINib(nibName: "UserContactCVCell", bundle: nil), forCellWithReuseIdentifier: "userContactCell")
    }
    private func loadUserJob() {
        if editingJob {
            jobTitleTextField.text = testUserJob.title
            companyNameTextField.text = testUserJob.companyName
            currentlyEmployed = testUserJob.currentEmployer
            beginDateMonthTextField.text = testUserJob.beginDate.dateValue().description
            beginDateYearTextField.text = testUserJob.beginDate.dateValue().description
            endDateMonthTextField.text = testUserJob.endDate.dateValue().description
            endDateYearTextField.text = testUserJob.endDate.dateValue().description
            locationTextField.text = userJob?.location
            descriptionTextField.text = testUserJob.description
            responsibilityCells = testUserJob.responsibilities
            //TODO: Add star situations, add contacts
        }
    }
    private func setupNavigationBar() {
        navigationItem.title = "Create new Job"
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    private func setupTextFields() {
        let textFields = [jobTitleTextField, companyNameTextField, beginDateYearTextField, beginDateMonthTextField, endDateYearTextField, endDateMonthTextField, locationTextField, descriptionTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
        for field in textFields {
            field?.delegate = self
            field?.setPadding()
            field?.setBottomBorder()
        }
    }
    @IBAction func deleteResponsibiltyCellButtonPressed(_ sender: UIButton) {
        // TODO: Have user confirm the responsibility is going to be deleted before deleting
        //        showAlert(title: "Are you sure?", message: "You are about to delete this resonsibility: \(userJobResponsibilities[sender.tag])")
        responsibilityCells.remove(at: sender.tag)
        switch sender.tag {
        case 1:
            responsibility2TextField.text = ""
        case 2:
            responsibility3TextField.text = ""
        default:
            break
        }
        responsibilities.remove(at: sender.tag)
    }
    @IBAction func addResponsibilityButtonPressed(_ sender: UIButton) {
        responsibilityCells.append("")
    }
    @IBAction func addContactButtonPressed(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    private func listenForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    private func configureCurrentlyEmployedButton(_ currentlyEmployed: Bool) {
        if let job = userJob {
            self.currentlyEmployed = job.currentEmployer
        }
        if currentlyEmployed {
            currentlyEmployedButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            currentlyEmployedButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    private func populateUserJobResponsibilities() {
        responsibilities.removeAll()
        let responsibilityFieldEntries = [responsibility1TextField.text, responsibility2TextField.text, responsibility3TextField.text]
        for entry in responsibilityFieldEntries {
            if entry != "" {
                responsibilities.append(entry ?? "N/A")
            }
        }
        dump(responsibilities)
    }
    //MARK: Save userJob
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        populateUserJobResponsibilities()
        let beginDateFromField = formatDates(month: beginDateMonthTextField.text ?? "", year: beginDateYearTextField.text ?? "")
        let endDateFromField = formatDates(month: endDateMonthTextField.text ?? "", year: endDateYearTextField.text ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let beginDateTimeStamp = Timestamp(date: (beginDateFromField ?? dateFormatter.date(from: "1/1970"))!)
        let endDateTimeStamp = Timestamp(date: (endDateFromField ?? Date()))
        let newUserJob = UserJob(id: UUID().uuidString, title: jobTitleTextField.text ?? "", companyName: companyNameTextField.text ?? "", location: locationTextField?.text ?? "", beginDate: beginDateTimeStamp, endDate: endDateTimeStamp, currentEmployer: currentlyEmployed, description: descriptionTextField.text ?? "", responsibilities: responsibilities, starSituationIDs: linkedStarSituations, interviewQuestionIDs: linkedInterviewQuestions)
        DatabaseService.shared.addToUserJobs(userJob: newUserJob, completion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to save job", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    let destVC = JobHistoryController(nibName: "JobHistoryXib", bundle: nil)
                    self?.show(destVC, sender: nil)
                    self?.showAlert(title: "Job Saved!", message: "Success")
                }
            }
        })
        if userContacts.count != 0 {
            for contact in userContacts {
                DatabaseService.shared.addContactsToUserJob(userJobId: newUserJob.id, contact: contact, completion: { [weak self] (results) in
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
    @IBAction func currentlyEmployedButtonPressed(_ sender: UIButton) {
        currentlyEmployed.toggle()
    }
    @objc func keyboardWillChange(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        var rect = self.view.frame
        rect.size.height -= keyboardSize.height
        let textFields = [jobTitleTextField, companyNameTextField, beginDateMonthTextField, beginDateYearTextField, endDateMonthTextField, endDateYearTextField,  locationTextField, descriptionTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
        for textField in textFields {
            if let activeTextField = textField,
                !rect.contains(activeTextField.frame.origin) {
                self.tableView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
        // Old keyboard handling code
        /*
         guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
         return
         }
         //         Move entire view by height of the keyboard and reset
         if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
         view.frame.origin.y = -keyboardRect.height
         } else {
         tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         view.frame.origin.y = 0
         }
         */
    }
    
    private func formatDates(month: String, year: String) -> Date? {
        let currentDate = Date()
        let compiledDate = "\(month)/\(year)"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/yyyy"
        let todaysDateStr = dateformatter.string(from: currentDate)
        let formattedDate = dateformatter.date(from: compiledDate)
        if currentDate < (formattedDate ?? dateformatter.date(from: "01/1970"))! {
            showAlert(title: "Invalid Date", message: "Please enter a date before: \(todaysDateStr)")
            return nil
        } else {
            return formattedDate
        }
    }
    
}
//MARK:- TableViewController Datasource/Delegate
extension JobEntryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Details"
        case 1:
            return "Description"
        case 2:
            return "Responsibilities"
        case 3:
            return "STAR Situations: \(userJob?.starSituationIDs.count ?? 0)"
        case 4:
            return "Contacts/Co-workers: \(userContacts.count)"
        default:
            return "What?"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        case 2:
            if responsibilityCells.count == 0 {
                return 1
            } else {
                return responsibilityCells.count
            }
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return jobTitleCell
            case 1:
                return companyTitleCell
            case 2:
                configureCurrentlyEmployedButton(currentlyEmployed)
                return currentEmployerCell
            case 3:
                return beginEmploymentDateCell
            case 4:
                return endEmploymentCell
            case 5:
                return locationCell
            default:
                return jobTitleCell
            }
        case 1:
            return descriptionCell
        case 2:
            switch indexPath.row {
            case 0:
                if editingJob {
                    responsibility1TextField.text = responsibilityCells[indexPath.row]
                }
                return mainResponsiblityCell
            case 1:
                if editingJob {
                    responsibility2TextField.text = responsibilityCells[indexPath.row]
                }
                return responsiblity2Cell
            case 2:
                if editingJob {
                    responsibility3TextField.text = responsibilityCells[indexPath.row]
                }
                return responsiblity3Cell
            default:
                if editingJob {
                    responsibility1TextField.text = responsibilityCells[indexPath.row]
                }
                return mainResponsiblityCell
            }
        case 3:
            switch indexPath.row {
            case 0:
                return addStarSituationCell
            default:
                return addStarSituationCell
            }
        case 4:
            switch indexPath.row {
            case 0:
                return userContactsCVCell
            default:
                return userContactsCVCell
            }
        default:
            break
        }
        return jobTitleCell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 2 {
            if indexPath.row > 0 {
                return .delete
            } else {
                return .none
            }
        } else {
            return .none
        }
    }
    // Swipe tableview cell for reponsibilities to delete
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if indexPath.section == 2 {
    //            if indexPath.row > 0 {
    //            if editingStyle == UITableViewCell.EditingStyle.delete {
    //                userJobResponsibilities.remove(at: indexPath.row)
    ////                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    //                }
    //            }
    //        }
    //    }
}
extension JobEntryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                currentlyEmployed.toggle()
            }
        }
    }
}

//MARK:- UITextField Delegate
extension JobEntryController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- UITextField Extension
extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.backgroundColor = UIColor.white.cgColor
    }
}
//MARK:- CollectionView Extension
extension JobEntryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
}
extension JobEntryController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contact = userContacts[indexPath.row]
        let contactViewController = CNContactViewController(forUnknownContact: contact.contactValue)
        navigationController?.pushViewController(contactViewController, animated: true)
    }
}
extension JobEntryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userContacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userContactCell", for: indexPath) as? UserContactCVCell else {
            fatalError("failed to dequeue userContactCell")
        }
        let contact = userContacts[indexPath.row]
        cell.configureCell(contact: contact)
        return cell
    }
    
    
}
//MARK:- CNContactPickerDelegate
extension JobEntryController: CNContactPickerDelegate {
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

extension UIViewController {
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(title: "Prev", style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
}
