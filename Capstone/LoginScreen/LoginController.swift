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
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var positionYConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signUpPrompt: UILabel!
    @IBOutlet weak var careerViewLabel: UILabel!
    
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
    //MARK:- Keyboard Handeling
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
    //MARK:- UI
    private func setUpUI() {
        logoImageView.layer.cornerRadius = AppRoundedViews.cornerRadius
        signUpButton.setTitleColor(AppColors.secondaryPurpleColor, for: .normal)
        signUpButton.titleLabel?.font = AppFonts.primaryFont
        loginButton.titleLabel?.font = AppFonts.primaryFont
        loginButton.setTitleColor(AppColors.whiteTextColor, for: .normal)
        loginButton.backgroundColor = AppColors.secondaryPurpleColor
        loginButton.layer.cornerRadius = AppRoundedViews.cornerRadius
        signUpPrompt.font = AppFonts.secondaryFont
        careerViewLabel.font = AppFonts.boldFont
        careerViewLabel.textColor = AppColors.primaryBlackColor
    }
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    //MARK:- Login functions
    @IBAction func loginButtonPressed(_ sender: TransitionButton) {
        sender.startAnimation()
        guard let email = emailTextField.text, !email.isEmpty else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: emailTextField.center.x - 10, y: emailTextField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: emailTextField.center.x + 10, y: emailTextField.center.y))
            emailTextField.layer.add(animation, forKey: "position")
            emailTextField.setBorder(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), width: 1.0)
            emailTextField.placeholder = "Please enter an email"
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
            passwordTextField.placeholder = "Please enter a password"
            sender.stopAnimation()
            return
        }
        AuthenticationSession.shared.signExisitingUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error signing in", message: error.localizedDescription)
                    sender.stopAnimation()
                }
            case .success:
                DispatchQueue.main.async {
                    self?.emailTextField.isHidden = true
                    sender.stopAnimation(animationStyle: .expand, completion: {
                        UIViewController.showMainAppView()
                    })
                }
            }
        }
    }
}
//MARK:- TextField Delegate
extension LoginController: UITextFieldDelegate {
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
