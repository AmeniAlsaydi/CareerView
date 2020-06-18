//
//  AboutThisAppViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class AboutThisAppViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    private func setupView() {
        imageView.layer.cornerRadius = 4
        
        textView.text = """
        This app was developed at Pursuit.org, over the course of 6 weeks by a team of 4 iOS developers for their capstone project. This app marks the completion of their 10 month training, to become developers.
        
        It was the goal of each dedicated developer on the project to build an experience that would create a positive impact on the world and help our community during moments of uncertainty.
        
        We hope this app helps you to keep track of your job history, jobs you have applied to, and sharpen your professional skills needed when interviewing for jobs.
        
        We are always open to feedback and encourage you to reach out to us directly with the "contact us" section on the profile.
        
        Good luck in all of your pursuits
        """
    }
}
