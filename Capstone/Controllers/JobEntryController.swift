//
//  JobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

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
    @IBOutlet var addContactCell: UITableViewCell!
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var currentlyEmployedButton: UIButton!
    
    @IBOutlet weak var beginDateMonthTextField: UITextField!
    @IBOutlet weak var beginDateYearTextField: UITextField!
    @IBOutlet weak var endDateMonthTextField: UITextField!
    @IBOutlet weak var endDateYearTextField: UITextField!
    @IBOutlet weak var addResponsibilityButton: UIButton!
    @IBOutlet weak var addStarSituationButton: UIButton!
    @IBOutlet weak var addContactButton: UIButton!
    
    //MARK:- Variables
    public var userJob: UserJob?
    private var currentlyEmployed: Bool = false {
        didSet {
            configureCurrentlyEmployedButton(currentlyEmployed)
        }
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupTextFields()
        setupNavigationBar()
    }
    private func configureView() {
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
    }
    private func setupNavigationBar() {
        navigationItem.title = "Create new Job"
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    private func setupTextFields() {
        jobTitleTextField.setPadding()
        jobTitleTextField.setBottomBorder()
        companyNameTextField.setPadding()
        companyNameTextField.setBottomBorder()
        
        beginDateMonthTextField.setPadding()
        beginDateMonthTextField.setBottomBorder()
        beginDateYearTextField.setPadding()
        beginDateYearTextField.setBottomBorder()
        endDateMonthTextField.setPadding()
        endDateMonthTextField.setBottomBorder()
        endDateYearTextField.setPadding()
        endDateYearTextField.setBottomBorder()
        
        let toolbar = UIToolbar(frame: CGRect(origin: .zero,
                                              size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        jobTitleTextField.inputAccessoryView = toolbar
        companyNameTextField.inputAccessoryView = toolbar
        beginDateMonthTextField.inputAccessoryView = toolbar
        beginDateYearTextField.inputAccessoryView = toolbar
        endDateMonthTextField.inputAccessoryView = toolbar
        endDateYearTextField.inputAccessoryView = toolbar
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
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("save pressed")
    }
    @IBAction func currentlyEmployedButtonPressed(_ sender: UIButton) {
        currentlyEmployed.toggle()
    }
    
}
//MARK:- TableViewController Datasource/Delegate
extension JobEntryController: UITableViewDataSource {
    //     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //         switch section {
    //         case 0:
    //             return "Job Title"
    //         default:
    //             return "What?"
    //         }
    //     }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        default:
            return jobTitleCell
        }
        
        
    }
}
extension JobEntryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            currentlyEmployed.toggle()        }
    }
}

//MARK:- UITextField Delegate
extension JobEntryController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        self.view.endEditing(true)
        return true
    }
}

//MARK:- UITextField Extension
extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
