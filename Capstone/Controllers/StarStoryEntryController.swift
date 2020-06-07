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
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var situationTextView: UITextView!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBOutlet weak var situationTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskTextViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var actionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var situationBkgdView: UIView!
    @IBOutlet weak var taskBkgdView: UIView!
    @IBOutlet weak var actionBkgdView: UIView!
    @IBOutlet weak var resultBkgdView: UIView!
    
    private var saveChoiceAsDefault = true
    
    private var starSituation: StarSituation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        navigationController?.navigationBar.topItem?.title = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        
        starStoryButton.layer.borderWidth = CGFloat(1.0)
        freeFormButton.layer.borderWidth = CGFloat(1.0)
        starStoryButton.layer.cornerRadius = 4
        starStoryButton.layer.masksToBounds = true
        freeFormButton.layer.cornerRadius = 4
        freeFormButton.layer.masksToBounds = true
        inputOptionView.layer.cornerRadius = 4
        inputOptionView.layer.masksToBounds = true
        
        situationTextView.delegate = self
        taskTextView.delegate = self
        actionTextView.delegate = self
        resultTextView.delegate = self
        
        situationTextView.layer.cornerRadius = 4
        taskTextView.layer.cornerRadius = 4
        actionTextView.layer.cornerRadius = 4
        resultTextView.layer.cornerRadius = 4
        setTextViewHeights()
        
        configureTextViews(view: situationBkgdView)
        configureTextViews(view: taskBkgdView)
        configureTextViews(view: actionBkgdView)
        configureTextViews(view: resultBkgdView)
        
    }
    private func configureTextViews(view: UIView) {
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 0.25
        view.layer.cornerRadius = 4
    }
    private func setTextViewHeights() {
        situationTextView.sizeToFit()
        situationTextViewHeightConstraint.constant = situationTextView.contentSize.height

        taskTextView.sizeToFit()
        taskTextViewHeightContraint.constant = taskTextView.contentSize.height

        actionTextView.sizeToFit()
        actionTextViewHeightConstraint.constant = actionTextView.contentSize.height

        resultTextView.sizeToFit()
        resultTextViewHeightConstraint.constant = resultTextView.contentSize.height
    }
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("Save pressed")
    }
    private func transitionFromOptionToMainView() {
        let duration = 1.0
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            self.inputOptionView.isHidden = true
            self.blurEffect.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func freeFormButtonPressed(_ sender: UIButton) {
        print("Free form button pressed")
        transitionFromOptionToMainView()
    }
    @IBAction func starStoryButtonPressed(_ sender: UIButton) {
        print("Star story button pressed")
        transitionFromOptionToMainView()
    }
    @IBAction func saveAsDefaultButtonPressed(_ sender: UIButton) {
        saveChoiceAsDefault.toggle()
        if saveChoiceAsDefault {
            saveAsDefaultButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            saveAsDefaultButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }
    }
    @IBAction func clearSituationButtonPressed(_ sender: UIButton) {
        situationTextView.text = ""
        setTextViewHeights()
    }
    @IBAction func clearTaskButtonPressed(_ sender: UIButton) {
        taskTextView.text = ""
        setTextViewHeights()
    }
    @IBAction func clearActionButtonPressed(_ sender: UIButton) {
        actionTextView.text = ""
        setTextViewHeights()
    }
    @IBAction func clearResultButtonPressed(_ sender: UIButton) {
        resultTextView.text = ""
        setTextViewHeights()
    }
    
}

extension StarStoryEntryController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setTextViewHeights()
    }
}
