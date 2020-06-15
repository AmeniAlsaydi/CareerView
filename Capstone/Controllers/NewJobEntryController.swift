//
//  NewJobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class NewJobEntryController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()

        // Do any additional setup after loading the view.
    }
    
    private func configureNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(saveJobButtonPressed(_:)))
    }
    

   @objc private func saveJobButtonPressed(_ sender: UIBarButtonItem) {
        // create new job and add to datebase
    print("create new job and add to datebase")
    }

}
