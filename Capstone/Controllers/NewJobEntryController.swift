//
//  NewJobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class NewJobEntryController: UIViewController {
    
    @IBOutlet weak var positionTitleTextField: FloatingLabelInput!
    @IBOutlet weak var companyNameTextField: FloatingLabelInput!
    @IBOutlet weak var locationTextField: FloatingLabelInput!
    @IBOutlet weak var descriptionTextField: FloatingLabelInput!
    @IBOutlet weak var beginDateTextField: FloatingLabelInput!
    @IBOutlet weak var endDateTextField: FloatingLabelInput!
    @IBOutlet weak var responsibility1TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility2TextField: FloatingLabelInput!
    @IBOutlet weak var responsibility3TextField: FloatingLabelInput!
    @IBOutlet weak var starSituationsCollectionView: UICollectionView!
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    @IBOutlet weak var currentEmployerButton: UIButton!
    
    private var isCurrentEmployer = false {
        didSet {
            if isCurrentEmployer {
                currentEmployerButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                currentEmployerButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleAllTextFields()
    }
    
    private func configureNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveJobButtonPressed(_:)))
    }
    
    private func styleAllTextFields() {
        
        let textFields = [companyNameTextField, positionTitleTextField, locationTextField, descriptionTextField, beginDateTextField, endDateTextField, responsibility1TextField, responsibility2TextField, responsibility3TextField]
        
        let _ = textFields.map { $0?.styleTextField()}
        
    }
    

   @objc private func saveJobButtonPressed(_ sender: UIBarButtonItem) {
        // create new job and add to datebase
    print("create new job and add to datebase")
    }
    
    
    @IBAction func currentEmployerButtonPressed(_ sender: UIButton) {
        isCurrentEmployer.toggle()
        
    }
    
    @IBAction func addStarSituationButtonPressed(_ sender: UIButton) {
        // display star situations
        // allow them to select
        // add ids to an array (used in the created of the job)
        // display them on the collection view
    }
    
    @IBAction func addContactsButtonPressed(_ sender: UIButton) {
        // display contacts
        // allow them to select
        // add contacts to an array (will be used to add to the contacts collection)
        // display them on the collection view
    }
    
}
