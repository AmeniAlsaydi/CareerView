//
//  JobEntryController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class JobEntryController: UIViewController {

    @IBOutlet var jobTitleCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
 

}
extension JobEntryController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         switch section {
         case 0:
             return "Job Title"
         default:
             return "What?"
         }
     }
      func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.section == 0 {
             if indexPath.row == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "jobTitleCell")!
                 return cell
             }
         }
         return jobTitleCell
     }
}
extension JobEntryController: UITableViewDelegate {
    
}
