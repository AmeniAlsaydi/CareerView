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
    // MARK: ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: TextFields
    @IBOutlet weak var positionTitleTextField: FloatingLabelInput!
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var descriptionTextField: FloatingLabelInput!
    @IBOutlet weak var beginDateTextField: FloatingLabelInput!
    @IBOutlet weak var endDateTextField: FloatingLabelInput!
    @IBOutlet weak var responsibility1TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility2TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility3TextField: FloatingLabelInput!
    @IBOutlet weak var addAnotherJobLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var contactsPromptLabel: UILabel!
    //MARK: CollectionViews
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    @IBOutlet weak var starSituationsCollectionView: UICollectionView!
    //MARK: Buttons
    @IBOutlet weak var currentEmployerButton: UIButton!
    // MARK: Constraints
    @IBOutlet weak var situationsCVHeight: NSLayoutConstraint!
    @IBOutlet weak var contactsCVHeight: NSLayoutConstraint!
    //MARK:- Variables
    lazy var textFields: [FloatingLabelInput] = [positionTitleTextField, companyNameTextField, locationTextField, descriptionTextField, beginDateTextField, endDateTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
    private var currentTextFieldIndex = 0
    private var activeTextField = UITextField()
    public var uniqueStarIDs = [String]() {
        didSet {
            getStarSituations()
        }
    }
    public var starSituationIDsToAdd = [String]() {
        didSet {
            uniqueStarIDs = starSituationIDsToAdd.removingDuplicates()
        }
    }
    public var starSituations = [StarSituation]() {
        didSet {
            if starSituations.count > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.situationsCVHeight.constant = 100
                    self.view.layoutIfNeeded()
                })
            }
            if starSituations.count == 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.situationsCVHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            self.starSituationsCollectionView.reloadData()
        }
    }
    private var contacts = [CNContact]()
    private var userContacts = [Contact]() {
        didSet {
            if userContacts.count > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.contactsCVHeight.constant = 50
                    self.view.layoutIfNeeded()
                })
                contactsPromptLabel.text = "* to remove a contact press and hold it until the menu appears"
                contactsPromptLabel.isHidden = false
            }
            
            if userContacts.count == 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.contactsCVHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
                contactsPromptLabel.isHidden = true
            }
            self.contactsCollectionView.reloadData()
        }
    }
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
       let longPress = UILongPressGestureRecognizer()
        longPress.minimumPressDuration = 0.3
        longPress.addTarget(self, action: #selector(didLongPress(_:)))
        return longPress
    }()
    private var isCurrentEmployer = false {
        didSet {
            if isCurrentEmployer {
                currentEmployerButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                endDateTextField.text = "Present"
                endDate = Date() // set end date to todays date
            } else {
                currentEmployerButton.setImage(UIImage(systemName: "square"), for: .normal)
                endDateTextField.text = nil
                
            }
        }
    }
    private let datePicker = UIDatePicker()
    private var beginDate: Date?
    private var endDate: Date?
    public var editingJob = false
    public var userJob: UserJob?
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        currentEmployerButton.tintColor = AppColors.primaryBlackColor
        configureNavBar()
        styleAllTextFields()
        createDatePicker()
        setUpDelegateForTextFields()
        configureContactsCollectionView()
        configureStarSituationCollectionView()
        configureSituationsCollectionView()
        loadUserJob()
        listenForKeyboardEvents()
        setUpTextFieldsReturnType()
        setUpContactsPromptLabel()
        scrollView.delegate = self
    }
    //MARK:- Funcs
    private func configureStarSituationCollectionView() {
        starSituationsCollectionView.backgroundColor = .secondarySystemBackground
    }
    private func configureContactsCollectionView() {
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
        contactsCollectionView.isUserInteractionEnabled = true
        contactsCollectionView.register(UINib(nibName: "UserContactCVCell", bundle: nil), forCellWithReuseIdentifier: "userContactCell")
        contactsCollectionView.backgroundColor = .secondarySystemBackground
        contactsCollectionView.addGestureRecognizer(longPressGesture)
    }
    private func configureSituationsCollectionView() {
        starSituationsCollectionView.delegate = self
        starSituationsCollectionView.dataSource = self
        starSituationsCollectionView.register(UINib(nibName: "BasicStarSituationCellXib", bundle: nil), forCellWithReuseIdentifier: "basicSituationCell")
    }
    private func listenForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillChange(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardSize, from: view.window)
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    private func loadUserJob() {
        if editingJob {
            addAnotherJobLabel.text = "Edit Job"
            promptLabel.text = "Edit and update changes to this job below"
            guard let job = userJob else { return }
            positionTitleTextField.text = job.title
            companyNameTextField.text = job.companyName
            isCurrentEmployer = job.currentEmployer
            locationTextField.text = job.location
            descriptionTextField.text = job.description
            beginDateTextField.text = job.beginDate.dateValue().dateString()
            endDateTextField.text = job.endDate.dateValue().dateString()
            starSituationIDsToAdd = job.starSituationIDs
            beginDate = job.beginDate.dateValue()
            endDate = job.endDate.dateValue()
            // handle optional responsibilities
            switch job.responsibilities.count {
            case 1:
                responsibility1TextField.text = job.responsibilities[0]
            case 2:
                responsibility2TextField.text = job.responsibilities[1]
            case 3:
                responsibility2TextField.text = job.responsibilities[1]
                responsibility3TextField.text = job.responsibilities[2]
            default:
                print("no responsibilties")
            }
            // handle contacts
            loadUserContacts(job)
        }
    }
    private func loadUserContacts(_ userJob: UserJob) {
        let userJobID = userJob.id
        DatabaseService.shared.fetchContactsForJob(userJobId: userJobID) { [weak self](result) in
            switch result {
            case .failure(let error):
                print("Failure loading jobs: \(error.localizedDescription)")
            case .success(let contactData):
                DispatchQueue.main.async {
                    self?.userContacts = contactData
                }
            }
        }
    }
    private func setUpContactsPromptLabel() {
        contactsPromptLabel.text = "* to remove a contact press and hold it until the menu appears"
        contactsPromptLabel.textColor = AppColors.darkGrayHighlightColor
        contactsPromptLabel.font = AppFonts.subtitleFont
    }
    private func setUpTextFieldsReturnType() {
        let _ = textFields.map { $0.returnKeyType = .next }
        responsibility3TextField.returnKeyType = .done
    }
    private func setUpDelegateForTextFields() {
        let _ = textFields.map { $0.delegate = self }
    }
    private func getStarSituations() {
        DatabaseService.shared.fetchStarSituations { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error getting star situations", message: "\(error.localizedDescription)")
            case .success(let situations):
                let situationsArr: [String] = self?.uniqueStarIDs ?? []
                let situationIDs = Set(situationsArr)
                self?.starSituations = situations.filter { situationIDs.contains($0.id) }
            }
        }
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
        currentTextFieldIndex += 1
        textFields[currentTextFieldIndex].becomeFirstResponder()
    }
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveJobButtonPressed(_:)))
        if editingJob {
            navigationItem.title = "Edit Job History Details"
        } else {
            navigationItem.title = "Enter New Job History Details"
        }
    }
    private func styleAllTextFields() {
        let textFields = [companyNameTextField, positionTitleTextField, locationTextField, descriptionTextField, beginDateTextField, endDateTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
        let _ = textFields.map { $0?.styleTextField()}
    }
    @objc private func saveJobButtonPressed(_ sender: UIBarButtonItem) {
        self.showIndicator()
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
                self.removeIndicator()
                self.showAlert(title: "Missing fields", message: "Check all mandatory fields.")
                return
        }
        let location = locationTextField.text
        guard let beginDate = beginDate else {
            self.removeIndicator()
            self.showAlert(title: "Missing fields", message: "Please enter the date you began this position.")
            return
        }
        // handle responsibilities:
        var responsibilties = [String]()
        guard let responsibility1 = responsibility1TextField.text, !responsibility1.isEmpty else {
            self.removeIndicator()
            self.showAlert(title: "Responsibilities?", message: "Please enter at least one of your responsibilites at this position.")
            return
        }
        responsibilties.append(responsibility1)
        // optional responsibilties
        if let responsibility2 = responsibility2TextField.text {
            responsibilties.append(responsibility2)
        }
        if let responsibility3 = responsibility3TextField.text {
            responsibilties.append(responsibility3)
        }
        let beginTimeStamp = Timestamp(date: beginDate)
        var endTimeStamp: Timestamp? = nil
        if isCurrentEmployer {
            endTimeStamp = Timestamp(date: Date())
        } else if let endDate = endDate {
            endTimeStamp = Timestamp(date: endDate)
        }
        let userJobToSave = UserJob(id: userJobId, title: jobTitle, companyName: companyName, location: location ?? "", beginDate: beginTimeStamp, endDate: endTimeStamp!, currentEmployer: isCurrentEmployer, description: description, responsibilities: responsibilties, starSituationIDs: uniqueStarIDs, interviewQuestionIDs: [])
        DatabaseService.shared.addToUserJobs(userJob: userJobToSave, completion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.removeIndicator()
                    self?.showAlert(title: "Failed to save job", message: error.localizedDescription)
                }
            case .success:
                // show alert and pop VC
                DispatchQueue.main.async {
                    if self?.editingJob ?? false {
                        self?.removeIndicator()
                        self?.showAlert(title: "Job Updated!", message: "Success!")  { (alert) in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        self?.removeIndicator()
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
                            self?.removeIndicator()
                            self?.showAlert(title: "Error saving contact", message: error.localizedDescription)
                        }
                    case .success:
                        self?.removeIndicator()
                        break
                    }
                })
            }
        }
        
        for starID in uniqueStarIDs {
            DatabaseService.shared.updateStarSituationWithUserJobId(userJobID: userJobId, starSitutationID: starID) { (result) in
                switch result {
                case .failure(let error):
                    print("error adding starID to userID: \(error)")
                case .success:
                    print("starID was added to userjob")
                }
            }
        }
    }
    @IBAction func currentEmployerButtonPressed(_ sender: UIButton) {
        isCurrentEmployer.toggle()
    }
    @IBAction func addStarSituationButtonPressed(_ sender: UIButton) {
        let starStoryVC = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        starStoryVC.starSituationIDs = starSituationIDsToAdd
        starStoryVC.isAddingToUserJob = true
        starStoryVC.delegate = self
        present(UINavigationController(rootViewController: starStoryVC), animated: true)
    }
    @IBAction func addContactsButtonPressed(_ sender: UIButton) {
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
    }
    private func retrieveContacts() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        let collection = gesture.location(in: contactsCollectionView)
        let indexPath = self.contactsCollectionView.indexPathForItem(at: collection)

        if let index = indexPath {
            let cell = contactsCollectionView.cellForItem(at: index)
            showMenu(cell: cell as! UserContactCVCell)
        }
        
    }
    private func showMenu(cell: UserContactCVCell) {
        guard let indexPath = contactsCollectionView.indexPath(for: cell) else {
            return
        }
        let contact = self.userContacts[indexPath.row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            if let job = self.userJob {
                self.deleteContact(userJob: job, contact: contact)
                self.userContacts.remove(at: indexPath.row)
                self.contactsCollectionView.reloadData()
            }
        }
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    private func deleteContact(userJob: UserJob, contact: Contact) {
        DatabaseService.shared.deleteContactFromJob(userJobID: userJob.id, contactID: contact.id) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Unable to remove contact at this time error: \(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Contact Removed", message: "Successfully removed contact from this job")
                }
            }
        }
    }
}
//MARK:- Extensions
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
//MARK: TextField Delegate
extension NewJobEntryController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as! FloatingLabelInput
        currentTextFieldIndex = textFields.firstIndex(of: activeTextField as! FloatingLabelInput)!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            currentTextFieldIndex += 1
            textFields[currentTextFieldIndex].becomeFirstResponder()
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
//MARK:- CollectionView Extension
extension NewJobEntryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contactsCollectionView {
            return CGSize(width: 150, height: 45) // FIXME: hardcoded values - this is no good
        } else if collectionView == starSituationsCollectionView {
            let maxsize: CGSize = UIScreen.main.bounds.size
            let width: CGFloat = maxsize.width * 0.9
            return CGSize(width: width, height: 90) // FIXME: hardcoded values - this is no good
        }
        return CGSize(width: 0, height: 0)
    }
}
extension NewJobEntryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contactsCollectionView {
            let contact = userContacts[indexPath.row]
            let contactViewController = CNContactViewController(forUnknownContact: contact.contactValue)
            navigationController?.pushViewController(contactViewController, animated: true)
        } else if collectionView == starSituationsCollectionView {
            // if star situation is selected - do we want/need this?
        }
    }
}
extension NewJobEntryController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contactsCollectionView {
            return userContacts.count
        } else if collectionView == starSituationsCollectionView {
            return starSituations.count
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contactsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userContactCell", for: indexPath) as? UserContactCVCell else {
                fatalError("failed to dequeue userContactCell")
            }
            let contact = userContacts[indexPath.row]
            cell.configureCell(contact: contact)
            return cell
        }
        else if collectionView == starSituationsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicSituationCell", for: indexPath) as? BasicStarSituationCell else {
                fatalError("could not down cast to BasicStarSituationCell")
            }
            let situation = starSituations[indexPath.row]
            cell.configureCell(situation)
            cell.delegate = self
            cell.backgroundColor = .white
            return cell
        }
        return UICollectionViewCell()
    }
}
extension NewJobEntryController: BasicSituationDelegate {
    func didPressMoreButton(starSituation: StarSituation, starSituationCell: BasicStarSituationCell) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertaction in self.deleteSituationID(starSituation: starSituation) }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    private func deleteSituationID(starSituation: StarSituation) {
        guard let index = uniqueStarIDs.firstIndex(of: starSituation.id) else {
            print("star situation id not found")
            return
        }
        uniqueStarIDs.remove(at: index)
        
        DatabaseService.shared.removeUserJobFromStarStory(starSitutationID: starSituation.id) { (result) in
            switch result {
            case .failure(let error):
                print("could not remove user job from star story: \(error)")
            case .success:
                print("successfully removed user job from star story")
            }
        }
    }
}
extension NewJobEntryController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            activeTextField.resignFirstResponder()
        }
    }
}

