//
//  NewApplicationController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class NewApplicationController: UIViewController {

    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var notesLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleAllTextFields()
        

    }
    private func styleAllTextFields() {
        
        let textFields = [companyNameTextField, jobTitleTextField, linkTextField, locationTextField, notesLabel]
        
        for field in textFields {
            field?.styleTextField()
        }
    }
    
    @IBAction func hasAppliedButtonChecked(_ sender: UIButton) {
        
        // animate and display the date applied stack
        
        
        
    }
    
    

}
