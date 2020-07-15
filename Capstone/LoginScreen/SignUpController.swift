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
    @IBOutlet weak var signUpButton: TransitionButton! // for ui purposes 
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var positionYConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginPrompt: UILabel!
    @IBOutlet weak var careerViewLabel: UILabel!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        setUpUI()
        registerForKeyBoardNotifications()
        originalState = positionYConstraint
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterForKeyBoardNotifications()
    }
    //MARK:- UI
    private func setUpUI() {
        loginButton.setTitleColor(AppColors.secondaryPurpleColor, for: .normal)
        loginButton.titleLabel?.font = AppFonts.primaryFont
        signUpButton.titleLabel?.font = AppFonts.primaryFont
        signUpButton.setTitleColor(AppColors.whiteTextColor, for: .normal)
        signUpButton.backgroundColor = AppColors.secondaryPurpleColor
        signUpButton.layer.cornerRadius = AppRoundedViews.cornerRadius
        careerViewLabel.font = AppFonts.boldFont
        careerViewLabel.textColor = AppColors.primaryBlackColor
        logoImageView.layer.cornerRadius = AppRoundedViews.cornerRadius
        loginPrompt.font = AppFonts.secondaryFont
    }
    //MARK:- Keyboard handeling
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
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(height: keyboardFrame.size.height / 2)
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
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
    @IBAction func signUpButonPressed(_ sender: TransitionButton) {
        sender.startAnimation()
        // reset border
        emailTextField.setBorder(color: nil, width: 0)
        passwordTextField.setBorder(color: nil, width: 0)
        // check fields
        guard let email = emailTextField.text, !email.isEmpty else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: emailTextField.center.x - 10, y: emailTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: emailTextField.center.x + 10, y: emailTextField.center.y))
            emailTextField.layer.add(animation, forKey: "position")
            emailTextField.setBorder(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 1.0)
            alertLabel.text = "please enter email to sign up"
            sender.stopAnimation()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            let animation1 = CABasicAnimation(keyPath: "position")
            animation1.duration = 0.07
            animation1.repeatCount = 4
            animation1.autoreverses = true
            animation1.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 10, y: passwordTextField.center.y))
            animation1.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 10, y: passwordTextField.center.y))
            passwordTextField.layer.add(animation1, forKey: "position")
            passwordTextField.setBorder(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 1.0)
            alertLabel.text = "please enter password to sign up"
            sender.stopAnimation()
            return
        }
        // create user
        AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.alertLabel.text = "\(error.localizedDescription)"
                    sender.stopAnimation()
                }
            case .success(let authDataResult):
                DispatchQueue.main.async {
                    //create a data base user and navigate to app view:
                    self?.createDatabaseUser(authDataResult: authDataResult)
                    sender.stopAnimation(animationStyle: .expand, completion: {
                        UIViewController.showMainAppView()
                    })
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
//MARK:- Textfield Delegate
extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailTextField.setBorder(color: AppColors.lightGrayHighlightColor.cgColor, width: 0)
        passwordTextField.setBorder(color: AppColors.lightGrayHighlightColor.cgColor, width: 0)
    }
}
