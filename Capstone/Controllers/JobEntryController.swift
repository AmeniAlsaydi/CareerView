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
    
    @IBOutlet var jobTitleCell: UITableViewCell!
    @IBOutlet var companyTitleCell: UITableViewCell!
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    
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
    }
    private func setupNavigationBar() {
        navigationItem.title = ""
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    private func setupTextFields() {
        jobTitleTextField.setPadding()
        jobTitleTextField.setBottomBorder()
        companyNameTextField.setPadding()
        companyNameTextField.setBottomBorder()
    }
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("save pressed")
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
         return 2
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
           return jobTitleCell
        case 1:
            return companyTitleCell
        default:
            return jobTitleCell
        }
        
        
     }
}
extension JobEntryController: UITableViewDelegate {

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
