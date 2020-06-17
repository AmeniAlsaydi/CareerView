//
//  ApplicationDetailController.swift
//  Capstone
//
//  Created by Amy Alsaydi on 5/26/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MapKit

class ApplicationDetailController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var appliedToLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var applicationStatusLabel: UILabel!
    @IBOutlet weak var appliedAsLabel: UILabel!
    @IBOutlet weak var remoteLabel: UILabel!
    @IBOutlet weak var hyperlinkLabel: UILabel!
    @IBOutlet weak var dateAppliedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var view1: ApplicationDetailView!
    @IBOutlet weak var view1Height: NSLayoutConstraint!
    
    @IBOutlet weak var view2: ApplicationDetailView!
    @IBOutlet weak var view2Height: NSLayoutConstraint!
    
    @IBOutlet weak var view3: ApplicationDetailView!
    @IBOutlet weak var view3Height: NSLayoutConstraint!
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    var jobApplication: JobApplication 
    
    private var interviewCount = 0
    
    private var interviewData = [Interview]()
    
    private var interviewViewHeight: NSLayoutConstraint!
        
    init(_ jobApplication: JobApplication) {
        self.jobApplication = jobApplication
        super.init(nibName: "ApplicationDetailXib", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailVC(application: jobApplication)
        getInterview(application: jobApplication)
        configureMapView()
        loadMap()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(moreOptionsButtonPressed(_:)))
    }
    
    public func getInterview(application: JobApplication) {
        DatabaseService.shared.getApplicationInterview(applicationID: application.id) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("couldnt get any interviews \(error.localizedDescription)")
            case .success(let interviews):
                DispatchQueue.main.async {
                    self?.interviewCount = interviews.count
                    self?.interviewData = interviews
                    self?.updateInterview()
                    print("This is the interview count \(self?.interviewCount ?? 0)")
                }
            }
        }
    }
    
    public func configureDetailVC(application: JobApplication) {
        
        appliedAsLabel.text = "Applied as: \(application.positionTitle)"
        appliedToLabel.text = application.companyName.capitalized
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            
            DispatchQueue.main.async {
                if application.receivedOffer {
                    self.progressBar.progress = 1.0
                    self.applicationStatusLabel.text = "Recieved Offer 🥳"
                } else if application.currentlyInterviewing {
                    self.progressBar.progress = 0.8
                    self.applicationStatusLabel.text = "Interviewing 🗣"
                } else if application.receivedReply {
                    self.progressBar.progress = 0.6
                    self.applicationStatusLabel.text = "Rcieved Reply 📨"
                } else if application.didApply {
                    self.progressBar.progress = 0.4
                    self.applicationStatusLabel.text = "Applied 📝"
                } else if application.interested {
                    self.progressBar.progress = 0.2
                    self.applicationStatusLabel.text = "Interested 👀"
                } else {
                    self.progressBar.progress = 0.0
                }
                
                if self.progressBar.progress == 1 {
                    timer.invalidate() 
                }
            }
        }
        
        switch application.remoteStatus {
        case true:
            remoteLabel.text = "Remote: Yes"
        case false:
            remoteLabel.text = "Remote: No"
        }
        
        if let submittedDate = application.dateApplied?.dateValue().dateString("MMM d, yyyy") {
            dateAppliedLabel.text = "Date Applied: \(submittedDate)"
        } else {
            dateAppliedLabel.text = "Date Applied: N/A"
        }
        
        hyperlinkLabel.text = application.positionURL
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false 
    }
    
    private func loadMap() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        annotation.title = jobApplication.companyName
        
        if let locationCoordinates = jobApplication.location {
            let coordinate = CLLocationCoordinate2DMake(Double(locationCoordinates.latitude), Double(locationCoordinates.longitude))
            annotation.coordinate = coordinate
            annotations.append(annotation)
        } else {
            mapHeight.constant = 0 
            mapView.isHidden = true
        }
        return annotations
    }
    
    private func updateInterview() {
        
        switch interviewCount {
        case 0 :
            view1.isHidden = true
            view2.isHidden = true
            view3.isHidden = true
        case 1:
            view1Height.constant = 100
            view2.isHidden = true
            view3.isHidden = true
            view1.interviewDateLabel.text = "Interview Date: \(interviewData[0].interviewDate?.dateValue().dateString() ?? "")"
            
            if interviewData[0].thankYouSent {
                view1.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
        case 2:
            view1Height.constant = 100
            view2Height.constant = 100
            view3.isHidden = true
            
            view1.interviewDateLabel.text = "Interview Date: \(interviewData[0].interviewDate?.dateValue().dateString() ?? "")"
            if interviewData[0].thankYouSent {
                view1.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
            view2.interviewDateLabel.text = "Interview Date: \(interviewData[1].interviewDate?.dateValue().dateString() ?? "")"
            if interviewData[1].thankYouSent {
                view2.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        case 3:
            view1Height.constant = 100
            view2Height.constant = 100
            view3Height.constant = 100
            view1.interviewDateLabel.text = "Interview Date #1 - \(interviewData[0].interviewDate?.dateValue().dateString() ?? "")"
            if interviewData[0].thankYouSent {
                view1.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
            view2.interviewDateLabel.text = "Interview Date #2 - \(interviewData[1].interviewDate?.dateValue().dateString() ?? "")"
            if interviewData[1].thankYouSent {
                view2.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
            
            view3.interviewDateLabel.text = "Interview Date #3 - \(interviewData[2].interviewDate?.dateValue().dateString() ?? "")"
            if interviewData[2].thankYouSent {
                view3.thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            }
        default:
            print("sorry no more than 3 interviews: this should be an alert controller -> suggest for user to get rid of old interviews")
        }
        view.layoutIfNeeded()
    }
    
    @objc
    func moreOptionsButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (actionSheet) in
            DatabaseService.shared.deleteJobApplication(applicationID: self.jobApplication.id) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    self?.showAlert(title: "Fail", message: "Couldnt delete \(error.localizedDescription)")
                case .success(_) :
                    self?.showAlert(title: "Success", message: "Application Deleted", completion: { [weak self] (alertAction) in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] (actionSheet) in
            let applicationEntryVC = NewApplicationController(nibName: "NewApplicationXib", bundle: nil)
            applicationEntryVC.editingApplication = true
            applicationEntryVC.jobApplication = self?.jobApplication
            applicationEntryVC.interviewData = self?.interviewData  
            self?.show(applicationEntryVC, sender: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(editAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ApplicationDetailController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemBlue
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
