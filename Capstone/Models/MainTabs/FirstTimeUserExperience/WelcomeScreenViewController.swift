//
//  WelcomeScreenViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/23/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Is their a better boolean to check?
        if isBeingDismissed {
            markFirstTimeLoginFalse()
        }
    }
    
    //MARK:- Private Funcs
    private func configureView() {
        logoImageView.layer.cornerRadius = AppRoundedViews.cornerRadius
        textView.font = AppFonts.secondaryFont
        welcomeLabel.font = AppFonts.primaryFont
        continueButton.tintColor = AppColors.primaryPurpleColor
        loadWelcomeText()
    }
    private func loadWelcomeText() {
        textView.text = """
        Thank you for downloading CareerView: Job Journal!
        
        We hope CareerView helps you to keep track and organize your journey throughout your career. Whether you need a place to store your master resume and the STAR stories that come from each job, or you're on the job hunt and need a single place to keep track of the applications, and practice for your interviews. We hope CareerView can be the app the enables you to succeed.
        
        To help you on that path, we have built a few tools for you to explore or use, including:
        
        Job History: Keep track of every job you have worked like you have worked, for easy reference when it comes time to build a new resume or fill out a job application. You can even keep track of your co-workers from each job!
        
        STAR Stories: Use the STAR method (Situation, Task, Action, Result), to answer tough behavioral interview questions, with examples from your own job history.
        
        Interview Questions: Practice common interview questions, and keep track of your own for future reference. You can also store answers, and link STAR stories you have entered, to keep track of how you would like to address these questions come interview time.
        
        Application Tracker: Use our Application tracker to store and update jobs you have applied to.
        
        
        There is a lot you can do with CareerView, feel free to explore and tap the info icon when you would like more information when using any part of our app.
        
        Good luck!
        """
    }
    private func markFirstTimeLoginFalse() {
        DatabaseService.shared.updateUserFirstTimeLogin(firstTimeLogin: false) { (result) in
            switch result {
            case.failure(let error):
                print("error updating user first time login: \(error.localizedDescription)")
            case .success:
                print("User first time login update successfully")
            }
        }
    }
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        markFirstTimeLoginFalse()
        dismiss(animated: true, completion: nil)
    }
}
