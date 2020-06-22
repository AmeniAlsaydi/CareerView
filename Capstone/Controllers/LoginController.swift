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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var positionYConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerForKeyBoardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyBoardNotifications()
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
    
    private func setUpUI() {
        signUpButton.setTitleColor(AppColors.secondaryPurpleColor, for: .normal)
        signUpButton.titleLabel?.font = AppFonts.primaryFont
        loginButton.titleLabel?.font = AppFonts.primaryFont
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
