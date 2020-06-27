//
//  JobHistoryExpandableCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/1/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import ContactsUI

protocol JobHistoryExpandableCellDelegate: AnyObject {
    func contextButtonPressed(userJob: UserJob)
    func starSituationsButtonPressed(userJob: UserJob)
}

class JobHistoryExpandableCell: FoldingCell {
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var jobTitleLabel2: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var companyNameLabel2: UILabel!
    @IBOutlet weak var jobDescriptionLabel2: UILabel!
    @IBOutlet weak var responsibilityOne: UILabel!
    @IBOutlet weak var responsibilityTwo: UILabel!
    @IBOutlet weak var responsibilityThree: UILabel!
    @IBOutlet weak var starSituationButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var unfoldedEditButton: UIButton!
    @IBOutlet weak var responsibilitesPromptLabel: UILabel!
    @IBOutlet weak var starsPromptLable: UILabel!
    @IBOutlet weak var contactsPromptLable: UILabel!
    @IBOutlet weak var purpleView: UIView!
    @IBOutlet weak var purpleViewUnFolded: UIView!
    
    weak var delegate: JobHistoryExpandableCellDelegate?
    private var userJobForDelegate: UserJob?
    
    var currentUserJob: UserJob?
    var contacts: [Contact]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @objc private func contextButtonPressed(_ sender: UIButton) {
        guard let userJob = userJobForDelegate else { return }
        delegate?.contextButtonPressed(userJob: userJob)
    }
    @objc private func starSituationButtonPressed(_ sender: UIButton) {
        guard let userJob = userJobForDelegate else { return }
        delegate?.starSituationsButtonPressed(userJob: userJob)
    }
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "UserContactCVCell", bundle: nil), forCellWithReuseIdentifier: "userContactCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColors.complimentaryBackgroundColor
        collectionView.layer.cornerRadius = AppRoundedViews.cornerRadius
    }
    private func setUpAppUI() {
        //Closed
        jobTitleLabel.font = AppFonts.semiBoldSmall
        jobTitleLabel.textColor = AppColors.primaryBlackColor
        dateLabel.font = AppFonts.secondaryFont
        dateLabel.textColor = AppColors.darkGrayHighlightColor
        companyNameLabel.font = AppFonts.primaryFont
        companyNameLabel.textColor = AppColors.darkGrayHighlightColor
        jobDescriptionLabel.font = AppFonts.secondaryFont
        jobDescriptionLabel.textColor = AppColors.darkGrayHighlightColor
        purpleView.backgroundColor = AppColors.primaryPurpleColor
        purpleView.clipsToBounds = true
        
        //Opened
        jobTitleLabel2.font = AppFonts.boldFont
        jobTitleLabel2.textColor = AppColors.primaryBlackColor
        dateLabel2.font = AppFonts.semiBoldSmall
        dateLabel2.textColor = AppColors.primaryBlackColor
        companyNameLabel2.font = AppFonts.semiBoldSmall
        companyNameLabel2.textColor = AppColors.primaryBlackColor
        jobDescriptionLabel2.font = AppFonts.primaryFont
        jobDescriptionLabel2.textColor = AppColors.primaryBlackColor
        responsibilitesPromptLabel.font = AppFonts.secondaryFont
        responsibilitesPromptLabel.textColor = AppColors.darkGrayHighlightColor
        responsibilityOne.font = AppFonts.semiBoldSmall
        responsibilityTwo.font = AppFonts.semiBoldSmall
        responsibilityThree.font = AppFonts.semiBoldSmall
        editButton.setImage(AppButtonIcons.optionsIcon, for: .normal)
        unfoldedEditButton.setImage(AppButtonIcons.optionsIcon, for: .normal)
        editButton.tintColor = AppColors.secondaryPurpleColor
        unfoldedEditButton.tintColor = AppColors.secondaryPurpleColor
        starsPromptLable.font = AppFonts.secondaryFont
        starsPromptLable.tintColor = AppColors.darkGrayHighlightColor
        contactsPromptLable.font = AppFonts.secondaryFont
        contactsPromptLable.tintColor = AppColors.darkGrayHighlightColor
        starSituationButton.setTitleColor(AppColors.secondaryPurpleColor, for: .normal)
        purpleViewUnFolded.backgroundColor = AppColors.primaryPurpleColor
    }
    func updateGeneralInfo(userJob: UserJob) {
        currentUserJob = userJob
        userJobForDelegate = userJob
        editButton.addTarget(self, action: #selector(contextButtonPressed(_:)), for: .touchUpInside)
        unfoldedEditButton.addTarget(self, action: #selector(contextButtonPressed(_:)), for: .touchUpInside)
        starSituationButton.addTarget(self, action: #selector(starSituationButtonPressed(_:)), for: .touchUpInside)
        jobTitleLabel.text = userJob.title
        companyNameLabel.text = "\(userJob.companyName)"
        jobDescriptionLabel.text = userJob.description
        dateLabel.text = "\(userJob.beginDate.dateValue().dateString()) - \(userJob.endDate.dateValue().dateString()) "
        jobTitleLabel2.text = userJob.title
        companyNameLabel2.text = "\(userJob.companyName) |"
        jobDescriptionLabel2.text = userJob.description
        dateLabel2.text = "\(userJob.beginDate.dateValue().dateString()) - \(userJob.endDate.dateValue().dateString()) "
        
        if userJob.responsibilities.count == 3 {
            responsibilityOne.text = "- \(userJob.responsibilities[0])"
            responsibilityTwo.text = "- \(userJob.responsibilities[1])"
            responsibilityThree.text = "- \(userJob.responsibilities[2])"
        } else if userJob.responsibilities.count == 2 {
            responsibilityOne.text = "- \(userJob.responsibilities[0])"
            responsibilityTwo.text = "- \(userJob.responsibilities[1])"
        } else if userJob.responsibilities.count == 1 {
            responsibilityOne.text = "- \(userJob.responsibilities[0])"
        }
        starSituationButton.setTitle(userJob.starSituationIDs.count.description, for: .normal)
        setUpAppUI()
        configureCollectionView()
    }
    func loadUserContacts(userJob: UserJob) {
        let userJobID = userJob.id
        DatabaseService.shared.fetchContactsForJob(userJobId: userJobID) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("Failure loading jobs: \(error.localizedDescription)")
            case .success(let contactData):
                DispatchQueue.main.async {
                    self?.contacts = contactData
                }
            }
        }
    }
    private func presentContactViewController(contact: Contact) {
        let contactViewController = CNContactViewController(forUnknownContact: contact.contactValue)
        let rootViewController = findViewController()
        rootViewController?.navigationController?.pushViewController(contactViewController, animated: true)
    }
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}
//TODO: Move this extension to extensions folder
extension Date {
    public func dateString(_ format: String = "MMM yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension JobHistoryExpandableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let contacts = contacts {
            return contacts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userContactCell", for: indexPath) as? UserContactCVCell else {
            fatalError("failed to dequeue contact cell")
        }
        guard let contact = contacts?[indexPath.row] else {
            return cell
        }
        cell.configureCell(contact: contact)
        return cell
    }
}
extension JobHistoryExpandableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let contact = contacts?[indexPath.row] else {
            return
        }
        presentContactViewController(contact: contact)
    }
}
