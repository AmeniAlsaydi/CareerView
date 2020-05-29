//
//  LoginController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Missing feilds", message: "Missing email or password.")
            return
        }
        
        AuthenticationSession.shared.signExisitingUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error signing in", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    UIViewController.showMainAppView()
                }
            }
        }
    }
    
   
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
