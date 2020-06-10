//
//  ApplicationTrackerController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class ApplicationTrackerController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var jobApplications = [JobApplication]() {
        didSet {
            if jobApplications.count == 0 {
                 collectionView.backgroundView = EmptyView(title: "No Applications yet", message: "Click on the add button on the top right and start keeping track of progress!", imageName: "square.and.pencil")
            } else {
                collectionView.backgroundView = nil
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getApplications()
//        jobApplications = [JobApplication]()
        configureNavBar()
        
    }
    
    private func getApplications() {
        DatabaseService.shared.fetchApplications { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error getting applications: \(error)")
            case .success(let jobApplications):
                self?.jobApplications = jobApplications
            }
        }
    }
    
    private func configureNavBar() {
        navigationItem.title = "Tracked Applications"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addJobApplicationButtonPressed(_:)))
    }
    
    
    private func configureCollectionView() {
       
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "JobApplicationCellXib", bundle: nil), forCellWithReuseIdentifier: "applicationCell")
        
    }
    
    @objc func addJobApplicationButtonPressed(_ sender: UIBarButtonItem) {
        let newApplicationVC = NewApplicationController(nibName: "NewApplicationXib", bundle: nil)
        show(newApplicationVC, sender: nil)
    }


}

extension ApplicationTrackerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobApplications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "applicationCell", for: indexPath) as? JobApplicationCell else {
            fatalError("could not down cast to application cell")
        }
        
        let application = jobApplications[indexPath.row]
        cell.configureCell(application: application)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aJobApplication = jobApplications[indexPath.row]
        let applicationDetailVC = ApplicationDetailController(aJobApplication)
        applicationDetailVC.jobApplication = aJobApplication
        show(applicationDetailVC, sender: nil)
    }
    
}


extension ApplicationTrackerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxsize.width * 0.9
        let itemHeight: CGFloat = maxsize.height * 0.15
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
       }
    
}
