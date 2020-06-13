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
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var positionTitleTextField: FloatingLabelInput!
    @IBOutlet weak var positionURLTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var notesTextField: FloatingLabelInput!
    @IBOutlet weak var dateTextField: FloatingLabelInput!
    
    // InterviewEntryViews + height constraints
    
    @IBOutlet weak var InterviewEntryView1: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView1Height: NSLayoutConstraint!
    
    @IBOutlet weak var InterviewEntryView2: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView2Height: NSLayoutConstraint!
    
    @IBOutlet weak var InterviewEntryView3: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView3Height: NSLayoutConstraint!
    
    @IBOutlet weak var addInterviewStack: UIStackView!
    
    @IBOutlet weak var recievedRelpyStackHeight: NSLayoutConstraint!
    
    // check mark buttons
    @IBOutlet weak var isRemoteButton: UIButton!
    @IBOutlet weak var hasAppliedButton: UIButton!
    @IBOutlet weak var hasRecievedReplyButton: UIButton!
    
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
        
        let textFields = [companyNameTextField, positionTitleTextField, positionURLTextField, locationTextField, notesTextField, dateTextField]
        
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
        // FIXME: have to also consider if they change their mind on the addition of an interview and would like delete
        
        interviewCount += 1
        
        switch interviewCount {
        case 1:
            interviewViewHeight = InterviewEntryView1Height
        case 2:
            interviewViewHeight = InterviewEntryView2Height
        case 3:
            interviewViewHeight = InterviewEntryView3Height
        default:
            print("sorry no more than 3 interviews: this should be an alert controller -> suggest for user to get rid of old interviews")
        }
        
        
        view.layoutIfNeeded() // force any pending operations to finish
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewViewHeight.constant = 150
            self.view.layoutIfNeeded()
        })
        
        
        if interviewCount == 3 {
            addInterviewStack.isHidden = true
        }
    }
    
    
    private func submitNewJobApplication() {
        
        // create id
        let jobID = UUID().uuidString
        
        // mandatory fields
        guard let companyName = companyNameTextField.text, !companyName.isEmpty, let positionTitle = positionTitleTextField.text, !positionTitle.isEmpty else {
            self.showAlert(title: "Missing fields", message: "Check all mandatory fields.")
            return
        }
        
        // date fields
               var dateApplied: Timestamp? = nil
               var deadline: Timestamp? = nil
               
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
        let locationAsString = locationTextField.text
        var locationAsCoordinates: GeoPoint? = nil
        
        // this is the problem
        if let location = locationAsString, !location.isEmpty {
            getCoordinateFrom(address: location) { [weak self] coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
                DispatchQueue.main.async {
                    locationAsCoordinates = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    
                    self?.createNewApplication(id: jobID, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, notes: notes, location: locationAsCoordinates, deadline: deadline, dateApplied: dateApplied, isInterviewing: isInterviewing)
                    
                    self?.addInterviews(jobID)
                    
                }
            }
        } else {
            createNewApplication(id: jobID, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, notes: notes, location: locationAsCoordinates, deadline: deadline, dateApplied: dateApplied, isInterviewing: isInterviewing)
            
            addInterviews(jobID)
        }
    }
    
    private func createNewApplication(id: String , companyName: String, positionTitle: String, positionURL: String?, notes: String?, location: GeoPoint?, deadline: Timestamp?, dateApplied: Timestamp?, isInterviewing: Bool) {
        
        
        // FIXME: this assumes that first time application means they have not recieved offer - should this be handled differently?
        let jobApplication = JobApplication(id: id, companyName: companyName, positionTitle: positionTitle, positionURL: positionURL, remoteStatus: isRemote, location: location, notes: notes, applicationDeadline: deadline, dateApplied: dateApplied, interested: true, didApply: hasApplied, currentlyInterviewing: isInterviewing, receivedReply: hasRecievedReply, receivedOffer: false)
        
        DatabaseService.shared.addApplication(application: jobApplication) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Error adding application: \(error)")
            case .success:
                print("success adding application")
                
                self?.showAlert(title: "Sucess!", message: "Your application was added!", completion: { (alertAction) in
                    self?.navigationController?.popViewController(animated: true)
                })
                
                
            }
        }
        
    }
    
    private func addInterviews(_ applicationID: String) {
        switch interviewCount {
        case 1:
            addInterview(InterviewEntryView1, applicationID: applicationID)
        case 2:
            addInterview(InterviewEntryView1, applicationID: applicationID)
            addInterview(InterviewEntryView2, applicationID: applicationID)
        case 3:
            addInterview(InterviewEntryView1, applicationID: applicationID)
            addInterview(InterviewEntryView2, applicationID: applicationID)
            addInterview(InterviewEntryView3, applicationID: applicationID)
        default:
            return 
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
        let interviewID = UUID().uuidString
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
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}


/*
 key board handling:
 - manipulate scroll view frame - height constraint
 - maniplute scroll view to move to current text field
 */
