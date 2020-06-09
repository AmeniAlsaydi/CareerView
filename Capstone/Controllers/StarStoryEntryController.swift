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
    
    @IBOutlet weak var situationLabel: UILabel!
    
    private var saveChoiceAsDefault = false
    var isEditingStarSituation = false

    private var guidedEntryPreference = GuidedStarSitutionInput.guided
    private var showUserOption = ShowUserStarInputOption.on {
        didSet {
            if showUserOption.rawValue == ShowUserStarInputOption.off.rawValue {
                transitionFromOptionToMainView()
                
                if guidedEntryPreference.rawValue == GuidedStarSitutionInput.freeForm.rawValue {
                    loadFreeFormView()
                }
            }
        }
    }
    
    var starSituation: StarSituation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStarSiuation()
        configureView()
        loadGuidedStarSituationPreference()
        
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
    private func loadGuidedStarSituationPreference() {
        if let userOptionPreference = UserPreference.shared.getPreferenceShowInputOption() {
            showUserOption = userOptionPreference
        }
        if let guidedPreference = UserPreference.shared.getGuidedSituationInputPreference() {
            guidedEntryPreference = guidedPreference
        }
    }
    private func updateStarSiuation() {
        situationTextView.text = starSituation?.situation
        if starSituation?.task != nil && starSituation?.action != nil && starSituation?.result != nil {
            taskTextView.text = starSituation?.task
            actionTextView.text = starSituation?.action
            resultTextView.text = starSituation?.result
        }
    }
    //MARK:- Save STAR Situation Function
    @objc private func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let situationText = situationTextView.text else {
            showAlert(title: "Missing Field", message: "Please enter a situation to save")
            return
        }
        let taskText = taskTextView.text
        let actionText = actionTextView.text
        let resultText = resultTextView.text
        var starSituationID = UUID().uuidString
        if isEditingStarSituation {
            guard let starID = starSituation?.id else {
                return
            }
            starSituationID = starID
        }
            
        let guidedStarSituation = StarSituation(situation: situationText, task: taskText, action: actionText, result: resultText, id: starSituationID, userJobID: nil, interviewQuestionsIDs: [""])
        let freeFormStarSituation = StarSituation(situation: situationText, task: nil, action: nil, result: nil, id: starSituationID, userJobID: nil, interviewQuestionsIDs: [""])
        if guidedEntryPreference.rawValue == GuidedStarSitutionInput.guided.rawValue {
            DatabaseService.shared.addToStarSituations(starSituation: guidedStarSituation, completion: { (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(title: "Star Story Saved!", message: "Success")
                    }
                }
            })
        } else {
            DatabaseService.shared.addToStarSituations(starSituation: freeFormStarSituation, completion: { (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self.showAlert(title: "Star Story Saved!", message: "Success")
                    }
                }
            })
        }
        //TODO: Activity Indicator
        let destinationViewController = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        show(destinationViewController, sender: nil)
    }
    private func loadFreeFormView() {
        taskBkgdView.isHidden = true
        actionBkgdView.isHidden = true
        resultBkgdView.isHidden = true
        situationLabel.text = "STAR Story"
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
        if saveChoiceAsDefault {
            UserPreference.shared.updatePreferenceShowUserInputOption(with: ShowUserStarInputOption.off)
        }
        loadFreeFormView()
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
//MARK:- TextView Delegate
extension StarStoryEntryController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setTextViewHeights()
    }
}
