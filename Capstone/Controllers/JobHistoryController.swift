//
//  JobHistoryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobHistoryController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let numberOfjobs = 5
    
    enum Const {
        static let closeCellHeight: CGFloat = 200
        static let openCellHeight: CGFloat = 800
        static let rowsCount = 5
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        checkFirstTimeLogin()
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        for _ in 0...Const.rowsCount {
            cellHeights.append(Const.closeCellHeight)
        }
        
        tableView.register(UINib(nibName: "UserJobFoldingCellXib", bundle: nil), forCellReuseIdentifier: "foldingCell")
    }
    private func configureNavBar() {
        navigationItem.title = "Job History: \(numberOfjobs) jobs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(segueToJobEntryVC(_:)))
    }
    @objc private func segueToJobEntryVC(_ sender: UIBarButtonItem) {
        let jobEntryController = JobEntryController(nibName: "JobEntryXib", bundle: nil)
        show(jobEntryController, sender: nil)
    }
    private var userData: User?
    private func getUserData() {
        DatabaseService.shared.fetchUserData { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error fetching user Data: \(error.localizedDescription)")
                }
            case .success(let userData):
                DispatchQueue.main.async {
                    self?.userData = userData
                }
            }
        }
    }
    private func checkFirstTimeLogin() {
        getUserData()
        guard let user = userData else { return }
            if user.firstTimeLogin {
                print("First time logging in")
            } else {
                print("User has logged in before")
            }
    }
    //TODO:- Add database function to grab user jobs data from firebase
    
}
extension JobHistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
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
    }
}
extension JobHistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:- add data count
        return Const.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO:- Update this function to take in foldable cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foldingCell", for: indexPath) as? FoldingCell else {
            fatalError("could not cast to jobHistoryBasicCell")
        }
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
}
