//
//  NewApplicationController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewApplicationController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: TextFields
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var positionTitleTextField: FloatingLabelInput!
    @IBOutlet weak var positionURLTextField: FloatingLabelInput!
    @IBOutlet weak var cityTextField: FloatingLabelInput!
    @IBOutlet weak var notesTextField: FloatingLabelInput!
    @IBOutlet weak var dateTextField: FloatingLabelInput!
    
    lazy var textFields: [FloatingLabelInput] = [companyNameTextField, positionTitleTextField, positionURLTextField, cityTextField, notesTextField, dateTextField]
    private var currentTextFieldIndex = 0
    
    //MARK: InterviewEntryViews + height constraints
    @IBOutlet weak var interviewEntryView1: InterviewEntryView!
    @IBOutlet weak var interviewEntryView1Height: NSLayoutConstraint!
    
    @IBOutlet weak var interviewEntryView2: InterviewEntryView!
    @IBOutlet weak var interviewEntryView2Height: NSLayoutConstraint!
    
    @IBOutlet weak var interviewEntryView3: InterviewEntryView!
    @IBOutlet weak var interviewEntryView3Height: NSLayoutConstraint!
    
    @IBOutlet weak var addInterviewStack: UIStackView!
    
    @IBOutlet weak var recievedRelpyStackHeight: NSLayoutConstraint!
    
    // MARK: Buttons
    @IBOutlet weak var isRemoteButton: UIButton!
    @IBOutlet weak var hasAppliedButton: UIButton!
    @IBOutlet weak var hasRecievedReplyButton: UIButton!
    
    public var editingApplication = false
    private var activeTextField = UITextField()
    
    public var jobApplication: JobApplication?  // FIXME: Is this the right way, use dependency injection?
    
    public var interviewData: [Interview]? // 0 1 2 
    
    private var hasApplied = false {
        didSet {
            view.layoutIfNeeded()
            if hasApplied {
                hasAppliedButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
                dateTextField.placeholder = "Date applied"
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.recievedRelpyStackHeight.constant = 22
                    self.view.layoutIfNeeded()
                })
                
            } else {
                hasAppliedButton.setImage(UIImage(systemName: "square"), for: .normal)
                
                dateTextField.placeholder = "Deadline"
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.recievedRelpyStackHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
                hasRecievedReply = false
            }
        }
    }
    
    private var isRemote = false {
        didSet {
            if isRemote {
                isRemoteButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                isRemoteButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
    private var hasRecievedReply = false {
        didSet {
            if hasRecievedReply {
                hasRecievedReplyButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                hasRecievedReplyButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
    private var date: Date?
    
    private var interviewViewHeight: NSLayoutConstraint!
    
    private var interviewCount = 0
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleAllTextFields()
        configureNavBar()
        createDatePicker()
        addTargets()
        loadApplicationToEdit()
        listenForKeyboardEvents()
        setUpTextFieldsReturnType()
        setUpDelegateForTextFields()
        scrollView.delegate = self
    }
    
    // MARK: Keyboard handling
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
    
    private func setUpTextFieldsReturnType() {
        let _ = textFields.map { $0.returnKeyType = .next }
    }
    
    private func setUpDelegateForTextFields() {
        let _ = textFields.map { $0.delegate = self }
    }
    
    
    private func loadApplicationToEdit() {
        
        if editingApplication {
            // update UI - Ameni
            
            guard let application = jobApplication else {fatalError("no application was passed")}
            companyNameTextField.text = application.companyName
            positionTitleTextField.text = application.positionTitle
            positionURLTextField.text = application.positionURL
             
            if let city = application.city {
                // if it has a city load it
                cityTextField.text = city
            }
            
            if application.didApply {
                hasApplied = true
                dateTextField.text = application.dateApplied?.dateValue().dateString("MM/dd/yyyy")
            } else {
                hasApplied = false
                dateTextField.text = application.applicationDeadline?.dateValue().dateString("MM/dd/yyyy")
            }
            
            isRemote = application.remoteStatus
            positionURLTextField.text = application.positionURL
            notesTextField.text = application.notes
        }
        
        editingInterviewViews()
    }
    
    private func addTargets() {
        interviewEntryView1.deleteButton.addTarget(self, action: #selector(view1DeleteButtonPressed), for: .touchUpInside)
        interviewEntryView2.deleteButton.addTarget(self, action: #selector(view2DeleteButtonPressed), for: .touchUpInside)
        interviewEntryView3.deleteButton.addTarget(self, action: #selector(view3DeleteButtonPressed), for: .touchUpInside)
    }
    
    @objc func view1DeleteButtonPressed() {
        interviewCount -= 1
        
        interviewEntryView1.hasInterviewData = false
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewEntryView1Height.constant = 0
            self.view.layoutIfNeeded()
        })
        
        addInterviewStack.isHidden = false
    }
    
    @objc func view2DeleteButtonPressed() {
        interviewCount -= 1
        
        interviewEntryView2.hasInterviewData = false
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewEntryView2Height.constant = 0
            self.view.layoutIfNeeded()
        })
        addInterviewStack.isHidden = false
    }
    
    @objc func view3DeleteButtonPressed() {
        interviewCount -= 1
        
        interviewEntryView3.hasInterviewData = false
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewEntryView3Height.constant = 0
            self.view.layoutIfNeeded()
        })
        
        addInterviewStack.isHidden = false
    }
    
    
    private func configureNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveJobApplicationButtonPressed(_:)))
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        // assign toolbar
        dateTextField.inputAccessoryView = toolbar
        
        // assign date picker to text feild
        dateTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        dateTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
        date = datePicker.date
        self.view.endEditing(true)
    }
    
    private func styleAllTextFields() {
        
        let textFields = [companyNameTextField, positionTitleTextField, positionURLTextField, cityTextField, notesTextField, dateTextField]
        
        for field in textFields {
            field?.styleTextField()
        }
    }
    
    @objc private func saveJobApplicationButtonPressed(_ sender: UIBarButtonItem) {
        // create new application and add to datebase
        submitNewJobApplication()
        // add the interview (if there is any as a collection to that application
    }
    
    @IBAction func isRemoteButtonPressed(_ sender: UIButton) {
        isRemote.toggle()
    }
    
    @IBAction func hasAppliedButtonChecked(_ sender: UIButton) {
        hasApplied.toggle()
    }
    
    @IBAction func hasRecievedButtonPressed(_ sender: UIButton) {
        hasRecievedReply.toggle()
    }
    
    @IBAction func addInterviewButtonPressed(_ sender: UIButton) {
        interviewCount += 1
        
        // if addInterview Button is pressed it checks the /hasInterviewData/ property of each view and presents the one that doesnt
        
        if  !interviewEntryView1.hasInterviewData {
            
            interviewViewHeight = interviewEntryView1Height
            interviewEntryView1.hasInterviewData = true
            
        } else if !interviewEntryView2.hasInterviewData {
            
            interviewViewHeight = interviewEntryView2Height
            interviewEntryView2.hasInterviewData = true
            
        } else if !interviewEntryView3.hasInterviewData {
            
            interviewViewHeight = interviewEntryView3Height
            interviewEntryView3.hasInterviewData = true
            
        }
        
        view.layoutIfNeeded() // force any pending operations to finish
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewViewHeight.constant = 160
            self.view.layoutIfNeeded()
        })
        
        
        if interviewCount == 3 {
            addInterviewStack.isHidden = true
        }
    }
    
    
    private func submitNewJobApplication() {
        // create id
        var jobID = ""
        
        if editingApplication {
            if let jobApplication = jobApplication {
                jobID = jobApplication.id
            }
        } else {
            jobID = UUID().uuidString
        }
        
        // mandatory fields
        guard let companyName = companyNameTextField.text, !companyName.isEmpty, let positionTitle = positionTitleTextField.text, !positionTitle.isEmpty else {
            self.showAlert(title: "Missing fields", message: "Check all mandatory fields.")
            return
        }
        
        // date fields
        var dateApplied: Timestamp? = nil
        var deadline: Timestamp? = nil
        
        if editingApplication {
            dateApplied = jobApplication?.dateApplied
            deadline = jobApplication?.applicationDeadline
        }
        
        if let date = date {
            if hasApplied { // if they have applied the date in that date field is the date they applied
                dateApplied = Timestamp(date: date)
            } else {
                deadline = Timestamp(date: date) // otherwise its the dead line date
            }
        }
        
        let isInterviewing = (interviewCount > 0)
        
        // optional fields
        let positionURL = positionURLTextField.text
        let notes = notesTextField.text
//        let locationAsString = cityTextField.text
//        var locationAsCoordinates: GeoPoint? = nil
     
        if let city = cityTextField.text, !city.isEmpty {
            // create job application with city
             createNewApplication(id: jobID, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, notes: notes, city: city, deadline: deadline, dateApplied: dateApplied, isInterviewing: isInterviewing)
            
        } else {
            // create job application with nil city
             createNewApplication(id: jobID, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, notes: notes, city: nil, deadline: deadline, dateApplied: dateApplied, isInterviewing: isInterviewing)
        }
    }
    
    private func createNewApplication(id: String , companyName: String, positionTitle: String, positionURL: String?, notes: String?, city: String?, deadline: Timestamp?, dateApplied: Timestamp?, isInterviewing: Bool) {
        
        
        // FIXME: this assumes that first time application means they have not recieved offer - should this be handled differently?
        let jobApplication = JobApplication(id: id, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, remoteStatus: isRemote, city: city, notes: notes, applicationDeadline: deadline, dateApplied: dateApplied, interested: true, didApply: hasApplied, currentlyInterviewing: isInterviewing, receivedReply: hasRecievedReply, receivedOffer: false)
        
        DatabaseService.shared.addApplication(application: jobApplication) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Error adding application: \(error)")
            case .success:
                print("success adding application")
                
                if self?.editingApplication ?? false {
                   
                    self?.addInterviews(id)
                    self?.showAlert(title: "Sucess!", message: "Your application was edited!", completion: { (alertAction) in
                        self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self?.addInterviews(id)
                    self?.showAlert(title: "Sucess!", message: "Your application was added!", completion: { (alertAction) in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                
            }
        }
    }
    
    private func addInterviews(_ applicationID: String) {
        
        if  interviewEntryView1.hasInterviewData {
            addInterview(interviewEntryView1, applicationID: applicationID)
        }
        
        if interviewEntryView2.hasInterviewData {
            addInterview(interviewEntryView2, applicationID: applicationID)
        }
        if interviewEntryView3.hasInterviewData {
            addInterview(interviewEntryView3, applicationID: applicationID)
        }
        
    }
    
    private func addInterview(_ view: InterviewEntryView, applicationID: String) {
        
        let notes = view.notesTextField.text
        let thankyouSent = view.thankYouSent
        guard let interviewDate = view.date else {
            showAlert(title: "Missing Fields", message: "Interview date is mandatory!")
            return
        }
        
        // create interview
        var interviewID = UUID().uuidString
        
        if let interview = view.interview {
            // if the interview has an interview (meaning the interview property is not nil we will update the interview using the interview ID
            interviewID = interview.id
        }
        
        
        let interview = Interview(id: interviewID, interviewDate: Timestamp(date: interviewDate), thankYouSent: thankyouSent, notes: notes)
        
        // post
        DatabaseService.shared.addInterviewToApplication(applicationID: applicationID, interview: interview) { (result) in
            switch result {
            case .failure(let error):
                print("error add interview to application: \(error)")
            case .success:
                print("interview was added successfully to application")
            }
        }
        
    }
    
    private func editingInterviewViews() {
        if editingApplication {
            guard let interviewData = interviewData else {return}
            
            // TODO: CREATE A FUNCTION THAT WILL SET UP VIEWS WITH INTEVIEWS
            
            switch interviewData.count {
            case 0:
                print("no interview")
            case 1:
                interviewEntryView1Height.constant = 150
                interviewEntryView1.dateTextField.text = interviewData[0].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView1.hasInterviewData = true
                interviewEntryView1.interview = interviewData[0]
                interviewEntryView1.date = interviewData[0].interviewDate?.dateValue()
            case 2:
                interviewEntryView1Height.constant = 150
                interviewEntryView2Height.constant = 150
                interviewEntryView1.dateTextField.text = interviewData[0].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView2.dateTextField.text = interviewData[1].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView1.interview = interviewData[0]
                interviewEntryView2.interview = interviewData[1]
                interviewEntryView1.hasInterviewData = true
                interviewEntryView2.hasInterviewData = true
                
                interviewEntryView1.date = interviewData[0].interviewDate?.dateValue()
                interviewEntryView2.date = interviewData[1].interviewDate?.dateValue()
                
            case 3:
                interviewEntryView1Height.constant = 150
                interviewEntryView2Height.constant = 150
                interviewEntryView3Height.constant = 150
                interviewEntryView1.dateTextField.text = interviewData[0].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView2.dateTextField.text = interviewData[1].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView3.dateTextField.text = interviewData[2].interviewDate?.dateValue().dateString("MM/dd/yyyy")
                interviewEntryView1.interview = interviewData[0]
                interviewEntryView2.interview = interviewData[1]
                interviewEntryView3.interview = interviewData[2]
                
                interviewEntryView1.hasInterviewData = true
                interviewEntryView2.hasInterviewData = true
                interviewEntryView3.hasInterviewData = true
                
                interviewEntryView1.date = interviewData[0].interviewDate?.dateValue()
                interviewEntryView2.date = interviewData[1].interviewDate?.dateValue()
                interviewEntryView3.date = interviewData[2].interviewDate?.dateValue()
                
                addInterviewStack.isHidden = true
            default:
                print("break")
            }
        }
    }
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}

//MARK: TextField Delegate

extension NewApplicationController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as! FloatingLabelInput
        // use active textfield to assign current textfield index
        
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

extension NewApplicationController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            activeTextField.resignFirstResponder()
        }
    }
}
