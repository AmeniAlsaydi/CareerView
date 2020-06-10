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
        styleTextField(companyNameTextField)
        styleTextField(jobTitleTextField)
        styleTextField(linkTextField)
        styleTextField(locationTextField)
        styleTextField(notesLabel)
    }
    
    
    private func styleTextField(_ textfield: UITextField) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    @IBAction func hasAppliedButtonChecked(_ sender: UIButton) {
        
        // animate and display the date applied stack
        
        
        
    }
    
    

}
