//
//  StarStoryEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class StarStoryEntryController: UIViewController {

    @IBOutlet weak var starStoryButton: UIButton!
    @IBOutlet weak var freeFormButton: UIButton!
    
    @IBOutlet weak var inputOptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        navigationController?.navigationBar.topItem?.title = "Back"
        navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(systemName: "lightbulb.fill"), for: .normal, style: .plain, barMetrics: .default)
        
        starStoryButton.layer.borderWidth = CGFloat(1.0)
        freeFormButton.layer.borderWidth = CGFloat(1.0)
        starStoryButton.layer.cornerRadius = 4
        starStoryButton.layer.masksToBounds = true
        freeFormButton.layer.cornerRadius = 4
        freeFormButton.layer.masksToBounds = true
        inputOptionView.layer.cornerRadius = 4
        inputOptionView.layer.masksToBounds = true
    }
}
