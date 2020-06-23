//
//  ApplicationTrackerController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ApplicationTrackerController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private var jobApplications = [JobApplication]() {
        didSet {
            if jobApplications.count == 0 {
                 collectionView.contentInsetAdjustmentBehavior = .never
                 collectionView.backgroundView = EmptyView(title: "No Applications yet", message: "Click on the add button on the top right and start keeping track of progress!", imageName: "chart.bar.fill")
            } else {
                collectionView.backgroundView = nil
                collectionView.contentInsetAdjustmentBehavior = .always
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    private var listener: ListenerRegistration?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureCollectionView()
//        getApplications()
//        configureNavBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configureCollectionView()
        getApplications()
        configureNavBar()
        collectionView.backgroundColor = AppColors.complimentaryBackgroundColor
    }
    override func viewDidDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
    private func setUpListener() {
         guard let user = Auth.auth().currentUser else {return}
        
        listener = Firestore.firestore().collection(DatabaseService.userCollection).document(user.uid).collection(DatabaseService.jobApplicationCollection).addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                print("Listener on job application not working: \(error.localizedDescription)")
                
            } else if let snapshot = snapshot {
                let applications = snapshot.documents.map { JobApplication($0.data())}
                self?.jobApplications = applications
            }
        }
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppButtonIcons.infoIcon, style: .plain, target: self, action: #selector(displayInfoViewController(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppButtonIcons.plusIcon, style: .plain, target: self, action: #selector(addJobApplicationButtonPressed(_:)))
        
    }
    
    @objc func displayInfoViewController(_ sender: UIBarButtonItem) {
        let infoVC = MoreInfoViewController(nibName: "MoreInfoControllerXib", bundle: nil)
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overFullScreen
        
        present(infoVC, animated: true)
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
        cell.maxWidth = collectionView.bounds.width
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
