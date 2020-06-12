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
    
    @IBOutlet weak var view1: InterviewEntryView!
    @IBOutlet weak var view1Height: NSLayoutConstraint!
    
    @IBOutlet weak var view2: InterviewEntryView!
    @IBOutlet weak var view2Height: NSLayoutConstraint!
    
    @IBOutlet weak var view3: InterviewEntryView!
    @IBOutlet weak var view3Height: NSLayoutConstraint!
    
    @IBOutlet weak var mapHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addInterviewButton: UIButton!
    
    var jobApplication: JobApplication
    
    private var interviewCount = 0
    
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
        configureMapView()
        loadMap()
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
    
    
    @IBAction func addInterviewPressed(_ sender: UIButton) {
        interviewCount += 1
        
        switch interviewCount {
        case 1:
            interviewViewHeight = view1Height
        case 2:
            interviewViewHeight = view2Height
        case 3:
            interviewViewHeight = view3Height
        default:
            print("sorry no more than 3 interviews: this should be an alert controller -> suggest for user to get rid of old interviews")
        }
        
        view.layoutIfNeeded() // force any pending operations to finish
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.interviewViewHeight.constant = 150
            self.view.layoutIfNeeded()
        })
        
        if interviewCount == 3 {
            addInterviewButton.isHidden = true
            // hide button maybe ?
        }
    }
    
    
    @IBAction func moreOptionsButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let editAction = UIAlertAction(title: "Edit", style: .default)
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


