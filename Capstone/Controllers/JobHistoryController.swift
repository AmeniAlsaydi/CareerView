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
    
    @IBOutlet var jobHistoryBasicCell: UITableViewCell! // TODO:- how would this work for configure cell method?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserJobBasicCellXib", bundle: nil), forCellReuseIdentifier: "jobHistoryBasicCell")
    }
    private func configureNavBar() {
        navigationItem.title = "Job History"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(segueToJobEntryVC(_:)))
    }
    @objc private func segueToJobEntryVC(_ sender: UIBarButtonItem) {
        
    }
    

    
}
extension JobHistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
extension JobHistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO:- add data count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "jobHistoryBasicCell", for: indexPath) as? JobHistoryBasicCell else {
            fatalError("could not cast to jobHistoryBasicCell")
        }
        cell.jobTitleLabel.text = "Gallery Attendant"
        cell.companyNameLabel.text = "The Noguchi Museum"
        cell.datesLabel.text = "Feb. 2019 - Sept. 2019"
        cell.jobDescriptionLabel.text = "I told people not to touch the rocks"
        return cell
    }
    
    
}
