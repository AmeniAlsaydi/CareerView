//
//  JobHistoryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobHistoryController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Variables
    private var displayContactCollectionView = false
    var userJobHistory = [UserJob]() {
        didSet {
            tableView.reloadData()
            setup()
            if userJobHistory.isEmpty {
                tableView.backgroundView = EmptyView.init(title: "Enter Your Job History", message: "Add any previous or current job history by pressing the plus button above", imageName: "rectangle.grid.1x2.fill")
                tableView.separatorStyle = .none
            } else {
                tableView.reloadData()
                tableView.backgroundView = nil
            }
        }
    }
    // Used to set the height for a closed/open cell for userJob on collectionView
    enum Const {
        static let closeCellHeight: CGFloat = 200
        static let openCellHeight: CGFloat = 640
    }
    var cellHeights = [CGFloat]()
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        view.backgroundColor = AppColors.complimentaryBackgroundColor
        loadUserJobs()
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadUserJobs()
    }
    //MARK:- Private Funcs
    private func configureTableView() {
        tableView.backgroundColor = AppColors.complimentaryBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserJobFoldingCellXib", bundle: nil), forCellReuseIdentifier: "foldingCell")
    }
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: userJobHistory.count)
    }
    private func configureNavBar() {
        navigationItem.title = "Job History"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.plusIcon, style: .plain, target: self, action: #selector(segueToJobEntryVC(_:)))
        AppButtonIcons.buttons.navBarBackButtonItem(navigationItem: navigationItem)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.infoIcon, style: .plain, target: self, action: #selector(presentInfoVC(_:)))
    }
    @objc private func segueToJobEntryVC(_ sender: UIBarButtonItem) {
        let jobEntryController = NewJobEntryController(nibName: "NewJobEntryXib", bundle: nil)
        jobEntryController.editingJob = false
        show(jobEntryController, sender: nil)
    }
    @objc private func presentInfoVC(_ sender: UIBarButtonItem) {
        let infoViewController = MoreInfoViewController(nibName: "MoreInfoControllerXib", bundle: nil)
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.modalPresentationStyle = .overFullScreen
        infoViewController.enterFrom = .jobHistory
        present(infoViewController, animated: true)
    }
    private func loadUserJobs() {
        self.showIndicator()
        DatabaseService.shared.fetchUserJobs { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.removeIndicator()
                print("error fetching user jobs\(error.localizedDescription)")
            case .success(let userJobHistory):
                DispatchQueue.main.async {
                    self?.removeIndicator()
                    self?.userJobHistory = userJobHistory.sorted(by: {$0.endDate.dateValue() > $1.endDate.dateValue()})
                }
            }
        }
    }
}
//MARK:- Extensions
extension JobHistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userJobHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foldingCell", for: indexPath) as? JobHistoryExpandableCell else {
            fatalError("could not cast to jobHistoryBasicCell")
        }
        let durations: [TimeInterval] = [0.26, 0.3, 0.3]
        cell.delegate = self
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
}
extension JobHistoryController: JobHistoryExpandableCellDelegate {
    func starSituationsButtonPressed(userJob: UserJob) {
        let destinationViewController = StarStoryMainController(nibName: "StarStoryMainXib", bundle: nil)
        destinationViewController.filterByJob = true
        destinationViewController.userJob = userJob
        destinationViewController.modalTransitionStyle = .crossDissolve
        destinationViewController.modalPresentationStyle = .overFullScreen
        present(UINavigationController(rootViewController: destinationViewController), animated: true)
    }
    func contextButtonPressed(userJob: UserJob) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertaction in self.deleteUserJob(userJob: userJob) }
        let editAction = UIAlertAction(title: "Edit", style: .default) {
            alertAction in self.editUserJob(userJob: userJob)
        }
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    private func editUserJob(userJob: UserJob) {
        let destinationViewController = NewJobEntryController(nibName: "NewJobEntryXib", bundle: nil)
        destinationViewController.userJob = userJob
        destinationViewController.editingJob = true
        AppButtonIcons.buttons.navBarBackButtonItem(navigationItem: navigationItem)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    private func deleteUserJob(userJob: UserJob) {
        self.showIndicator()
        guard let index = userJobHistory.firstIndex(of: userJob) else {
            return }
        DispatchQueue.main.async {
            DatabaseService.shared.removeUserJob(userJobId: userJob.id) {
                [weak self] (result) in
                switch result {
                case .failure(let error):
                    self?.removeIndicator()
                    self?.showAlert(title: "Failed to delete job", message: error.localizedDescription)
                case .success:
                    self?.removeIndicator()
                    self?.showAlert(title: "Success", message: "User job deleted")
                    self?.userJobHistory.remove(at: index)
                }
            }
        }
    }
}
extension JobHistoryController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JobHistoryExpandableCell
        displayContactCollectionView.toggle()
        let aUserJobHistory = userJobHistory[indexPath.row]
        if displayContactCollectionView == true {
            cell.loadUserContacts(userJob: aUserJobHistory)
        }
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as JobHistoryExpandableCell = cell else {
            return
        }
        cell.backgroundColor = .clear
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        let aUserJobHistory = userJobHistory[indexPath.row]
        cell.updateGeneralInfo(userJob: aUserJobHistory)
        
    }
}
