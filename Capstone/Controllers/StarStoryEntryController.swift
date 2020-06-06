//
//  StarStoryEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StarStoryEntryController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        navigationItem.backBarButtonItem?.title = "Back"
    }
}
