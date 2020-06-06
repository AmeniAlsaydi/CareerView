//
//  ChildView.swift
//  Capstone
//
//  Created by casandra grullon on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FilterMenuViewController: UIViewController {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    
    public var filterState: FilterState = .all
    
    override func viewDidLoad() {
        updateUI()
        halfFrame()
    }
    private func halfFrame() {
        let width = view.frame.width / 2
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: width, height: view.frame.height)
    }
    private func updateUI() {
        if filterState == .all {
            allButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .saved {
            savedButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .common {
            commonButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .custom {
            customButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    @IBAction func allButtonPressed(_ sender: UIButton) {
        filterState = .all
    }
    @IBAction func savedButtonPressed(_ sender: UIButton){
        filterState = .saved
    }
    @IBAction func commonButtonPressed(_ sender: UIButton) {
        filterState = .common
    }
    @IBAction func customButtonPressed(_ sender: UIButton) {
        filterState = .custom
    }
    @IBAction func setFilterButtonPressed(_ sender: UIButton) {
        let interviewQuestionsVC = InterviewQuestionsMainController()
        interviewQuestionsVC.filterState = filterState
        dismiss(animated: true)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
