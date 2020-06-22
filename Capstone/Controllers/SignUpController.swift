//
//  SignUpController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/27/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton! // for ui purposes 
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var positionYConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        setUpUI()
        registerForKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyBoardNotifications()
    }
    
    private func setUpUI() {
        loginButton.setTitleColor(AppColors.secondaryPurpleColor, for: .normal)
        loginButton.titleLabel?.font = AppFonts.primaryFont
        signUpButton.titleLabel?.font = AppFonts.primaryFont
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    private var isKeyboardThere = false
    
    private var originalState: NSLayoutConstraint!
    
    private var originalStack: NSLayoutConstraint!
    
    private func registerForKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        print(keyboardFrame)
        print(keyboardFrame.size.height)
        moveKeyboardUp(height: keyboardFrame.size.height / 2)
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        resetUI()
    }
    
    private func resetUI() {
        isKeyboardThere = false
        positionYConstraint.constant -= originalState.constant
        stackViewHeight.constant = 150
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func moveKeyboardUp(height: CGFloat) {
        if isKeyboardThere {return}
        originalState = positionYConstraint
        originalStack = stackViewHeight
        isKeyboardThere = true
        positionYConstraint.constant -= height
        stackViewHeight.constant += height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func signUpButonPressed(_ sender: UIButton) {
        // reset border
        emailTextField.setBorder(color: nil, width: 0)
        passwordTextField.setBorder(color: nil, width: 0)
        
        // check fields
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.setBorder(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 1.0)
            alertLabel.text = "please enter email to sign up"
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.setBorder(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 1.0)
            alertLabel.text = "please enter password to sign up"
            return
        }
        
        // create user
        AuthenticationSession.shared.createNewUser(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error Signing up", message: "\(error.localizedDescription)")
                    
                }
            case .success(let authDataResult):
                DispatchQueue.main.async {
                    //create a data base user and navigate to app view:
                    self.createDatabaseUser(authDataResult: authDataResult)
                }
            }
        }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
           DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult) { [weak self] (result) in
               switch result {
               case .failure(let error):
                   self?.showAlert(title: "Account error", message: error.localizedDescription)
               case .success:
                   DispatchQueue.main.async {
                    
                    UIViewController.showMainAppView()
                    
                   }
                   
               }
           }
       }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}


extension UITextField {
    public func setBorder(color: CGColor?, width: CGFloat) {
        self.layer.borderWidth = width
        
        if color != nil {
            self.layer.borderColor = color
        } else {
            self.layer.borderColor = nil
        }
    }
}
