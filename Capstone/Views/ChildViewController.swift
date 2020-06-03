//
//  ChildView.swift
//  Capstone
//
//  Created by casandra grullon on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol ChildViewControllerActions {
    func userEnteredAnswer(childViewController: ChildViewController, answer: String)
    //func userPressedCancel()
}

class ChildViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var answerTextfield: UITextField!
    
    public var delegate: ChildViewControllerActions?
    
    override func viewDidLoad() {
        answerTextfield.delegate = self
        //TODO: Keyboard handeling
        view.backgroundColor = .systemBackground
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        //upload answer to firebase
        //dismiss child view controller
        guard let userAnswer = answerTextfield.text, !userAnswer.isEmpty else {
            doneButton.isEnabled = false
            return
        }
        delegate?.userEnteredAnswer(childViewController: self, answer: userAnswer)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        //dismiss child view controller
        //dismiss(animated: true)???
    }

}
extension ChildViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
