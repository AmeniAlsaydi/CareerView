//
//  NewApplicationController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class NewApplicationController: UIViewController {
    
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var jobTitleTextField: FloatingLabelInput!
    @IBOutlet weak var linkTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var notesLabel: FloatingLabelInput!
    @IBOutlet weak var deteTextField: FloatingLabelInput!
   
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
        deteTextField.inputAccessoryView = toolbar
        
        // assign date picker to text feild
        deteTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        deteTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
        self.view.endEditing(true)
    }
    
    private func styleAllTextFields() {

        let textFields = [companyNameTextField, jobTitleTextField, linkTextField, locationTextField, notesLabel, deteTextField]

        for field in textFields {
            field?.styleTextField()
        }
    }
    
    @objc private func saveJobApplicationButtonPressed(_ sender: UIBarButtonItem) {
        // create new application and add to datebase
        // add the interview (if there is any as a collection to that application 
        
    }
    
    @IBAction func hasAppliedButtonChecked(_ sender: UIButton) {
        
        // animate and display the date applied stack
        
        
    }
    
    
    @IBAction func addInterviewButtonPressed(_ sender: UIButton) {
        // present a view with prepopulated feilds
        // i think the way i want to do this is animated the height of a view from 0 -> #
        // this means ill have all 3 interview views already there and if the user wants to add a new one the height of the one after will increase
        // i have to also consider if they change their mind on the addition of an interview
        
        // TODO:
        // create the interview view
        // have it require an initializer that takes in a number that will be assigned to the label on the view that tells them which interview theyre entering
        
        
    }
    
    

}
