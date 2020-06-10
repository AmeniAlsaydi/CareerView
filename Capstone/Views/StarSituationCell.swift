//
//  StarStiuationCell.swift
//  Capstone
//
//  Created by casandra grullon on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol StarSituationCellDelegate: AnyObject {
    func longPressOnStarSituation(starSituation: StarSituation, starSituationCell: StarSituationCell)
    func editStarSituationPressed(starSituation: StarSituation, starSituationCell: StarSituationCell)
}

class StarSituationCell: UICollectionViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var numberOfQuestions: UILabel!
    @IBOutlet weak var situationLabel: UILabel!
    
    weak var delegate: StarSituationCellDelegate?
    private var starSituationForDelegate: StarSituation?
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        delegate?.longPressOnStarSituation(starSituation: starSituationForDelegate!, starSituationCell: self)
    }
    @objc private func editButtonPressed(_ sender: UIButton) {
        delegate?.editStarSituationPressed(starSituation: starSituationForDelegate!, starSituationCell: self)
    }
    override func layoutSubviews() {
        self.layer.borderWidth = 2
        //let purple = #colorLiteral(red: 0.305962503, green: 0.1264642179, blue: 0.6983457208, alpha: 1)
        //self.layer.borderColor = purple as! CGColor
        self.layer.cornerRadius = 13
        addGestureRecognizer(longPressGesture)
    }
    public func configureCell(starSituation: StarSituation) {
        editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
        jobTitleLabel.text = starSituation.userJobID
        numberOfQuestions.text = "\(starSituation.interviewQuestionsIDs.count) questions"
        situationLabel.text = starSituation.situation
        starSituationForDelegate = starSituation
    }
    
//    @IBAction func editButtonPressed(_ sender: UIButton) {
//        //TODO: segues to StarStoryEntryVC
//        //TODO: create delegate
//    }
}
