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
    @IBOutlet weak var saveAsDefaultButton: UIButton!
    
    @IBOutlet weak var inputOptionView: UIView!
    
    private var saveChoiceAsDefault = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        navigationController?.navigationBar.topItem?.title = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        
        starStoryButton.layer.borderWidth = CGFloat(1.0)
        freeFormButton.layer.borderWidth = CGFloat(1.0)
        starStoryButton.layer.cornerRadius = 4
        starStoryButton.layer.masksToBounds = true
        freeFormButton.layer.cornerRadius = 4
        freeFormButton.layer.masksToBounds = true
        inputOptionView.layer.cornerRadius = 4
        inputOptionView.layer.masksToBounds = true
    }
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("Save pressed")
    }
    @IBAction func freeFormButtonPressed(_ sender: UIButton) {
        print("Free form button pressed")
        inputOptionView.isHidden = true
    }
    @IBAction func starStoryButtonPressed(_ sender: UIButton) {
        print("Star story button pressed")
        inputOptionView.isHidden = true
    }
    @IBAction func saveAsDefaultButtonPressed(_ sender: UIButton) {
        saveChoiceAsDefault.toggle()
        if saveChoiceAsDefault {
            saveAsDefaultButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            saveAsDefaultButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
    }
    
}
