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
    
    var userJobHistory = [UserJob]() {
        didSet {
            self.tableView.reloadData()
            self.setup()
        }
    }
    
    enum Const {
        static let closeCellHeight: CGFloat = 180
        static let openCellHeight: CGFloat = 620
    }
    
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        loadUserJobs()
        setup()
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserJobFoldingCellXib", bundle: nil), forCellReuseIdentifier: "foldingCell")
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: userJobHistory.count)
    }

    private func configureNavBar() {
         navigationItem.title = "CallBack"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(segueToJobEntryVC(_:)))
    }
    @objc private func segueToJobEntryVC(_ sender: UIBarButtonItem) {
        let jobEntryController = JobEntryController(nibName: "JobEntryXib", bundle: nil)
        show(jobEntryController, sender: nil)
    }
    
    //TODO:- Add database function to grab user jobs data from firebase
    private func loadUserJobs() {
        DatabaseService.shared.fetchUserJobs { (result) in
            switch result {
            case .failure(let error):
                print("error fetching user jobs\(error.localizedDescription)")
            case .success(let userJobHistory):
                DispatchQueue.main.async {
                    self.userJobHistory = userJobHistory
                }
            }
        }
    }
}

extension JobHistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:- add data count
        return userJobHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO:- Update this function to take in foldable cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foldingCell", for: indexPath) as? FoldingCell else {
            fatalError("could not cast to jobHistoryBasicCell")
        }
        let durations: [TimeInterval] = [0.26, 0.3, 0.3]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
}

extension JobHistoryController: UITableViewDelegate {
     func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        
        let aUserJobHistory = userJobHistory[indexPath.row]
        cell.updateGeneralInfo(userJob: aUserJobHistory)
    }
}

