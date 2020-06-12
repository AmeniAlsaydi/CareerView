//
//  NewApplicationController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import Firebase

class NewApplicationController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var jobTitleTextField: FloatingLabelInput!
    @IBOutlet weak var linkTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var notesLabel: FloatingLabelInput!
    @IBOutlet weak var dateTextField: FloatingLabelInput!
    
    // InterviewEntryViews + height constraints
    
    @IBOutlet weak var InterviewEntryView1: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView1Height: NSLayoutConstraint!
    
    @IBOutlet weak var InterviewEntryView2: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView2Height: NSLayoutConstraint!
    
    @IBOutlet weak var InterviewEntryView3: InterviewEntryView!
    @IBOutlet weak var InterviewEntryView3Height: NSLayoutConstraint!
    
    @IBOutlet weak var addInterviewStack: UIStackView!
    
    // check mark buttons
    @IBOutlet weak var isRemoteButton: UIButton!
    @IBOutlet weak var hasAppliedButton: UIButton!
    
    private var hasApplied = false {
        didSet {
            if hasApplied {
                hasAppliedButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                
                dateTextField.placeholder = "Date applied"
                
            } else {
                hasAppliedButton.setImage(UIImage(systemName: "square"), for: .normal)
                
                dateTextField.placeholder = "Deadline"
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

        let textFields = [companyNameTextField, jobTitleTextField, linkTextField, locationTextField, notesLabel, dateTextField]

        for field in textFields {
            field?.styleTextField()
        }
    }
    
    @objc private func saveJobApplicationButtonPressed(_ sender: UIBarButtonItem) {
        // create new application and add to datebase
        createJobApplication()
        // add the interview (if there is any as a collection to that application
        
        
    }
    @IBAction func isRemoteButtonPressed(_ sender: UIButton) {
        isRemote.toggle()
    }
    
    @IBAction func hasAppliedButtonChecked(_ sender: UIButton) {
        hasApplied.toggle()
    }
    
    
    
    @IBAction func addInterviewButtonPressed(_ sender: UIButton) {
        // i have to also consider if they change their mind on the addition of an interview and would like delete
        
        // TODO:
        // create the interview view
        // have it require an initializer that takes in a number that will be assigned to the label on the view that tells them which interview theyre entering
 
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
            // hide button maybe ?
        }
        
    }
    
    
    private func createJobApplication() {
        
        // create id
        let jobID = UUID().uuidString
        
        // mandatory fields
        // link should also be optional
        guard let companyName = companyNameTextField.text, !companyName.isEmpty, let jobTitle = jobTitleTextField.text, !jobTitle.isEmpty else {
            self.showAlert(title: "Missing fields", message: "Check all fields.")
            return
        }
        
        // optional fields
        let link = linkTextField.text
        // location
        
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
        
        // this assumes that first time application means they have not recieved offer
        let jobApplication = JobApplication(id: jobID, companyName: companyName, positionTitle: jobTitle, positionURL: link, remoteStatus: isRemote, applicationDeadline: deadline, dateApplied: dateApplied, interested: true, didApply: hasApplied, currentlyInterviewing: isInterviewing, receivedReply: false, receivedOffer: false)
        
//        JobApplication(id: <#T##String#>, companyName: <#T##String#>, positionTitle: <#T##String#>, positionURL: <#T##String?#>, remoteStatus: <#T##Bool#>, location: <#T##GeoPoint?#>, notes: <#T##String?#>, applicationDeadline: <#T##Timestamp?#>, dateApplied: <#T##Timestamp?#>, interested: <#T##Bool#>, didApply: <#T##Bool#>, currentlyInterviewing: <#T##Bool#>, receivedReply: <#T##Bool#>, receivedOffer: <#T##Bool#>)
        
        DatabaseService.shared.addApplication(application: jobApplication) { (result) in
            switch result {
            case .failure(let error):
                print("Error adding application: \(error)")
            case .success:
                print("success adding application")
                // self.navigationController?.popViewController(animated: true)
            }
        }
        
               
    }
}


/*
 key board handling:
 - manipulate scroll view frame - height constraint
 - maniplute scroll view to move to current text field
 */
