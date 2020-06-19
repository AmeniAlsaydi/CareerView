//
//  FAQViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

struct FAQInfo {
    let title: String
    let description: String
    
    static func loadFAQs() -> [FAQInfo] {
        return [
            FAQInfo(title: "How am I supposed to use the job history?", description: "Job History is meant a \"master resume\" of sorts, allowing you to keep track of your entire job history. To be used when creating new resumes, applying to jobs, or simply keeping track of your career over time"),
            FAQInfo(title: "Where does all of this info go?", description: "We keep a private, secure server on firebase for user data"),
            FAQInfo(title: "What if I don't want this info uploaded?", description: "We are working on an update to allowe the user to keep all data local"),
            FAQInfo(title: "What is a STAR story?", description: "A STAR story is an example of how you should be answering behavioral interview questions. The general structure of the answer should follow: Situation, Task, Action, Result")
        ]
    }
}

class FAQViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var FAQs = [FAQInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        loadFAQInfo()
    }
    private func configureNavBar() {
        navigationItem.title = "FAQs"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FAQCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "FAQCell")
    }
    private func loadFAQInfo() {
        FAQs = FAQInfo.loadFAQs()
    }
}

extension FAQViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let faq = FAQs[indexPath.row]
        let label = UILabel(frame: CGRect.zero)
        label.text = faq.description
        label.sizeToFit()
        let maxWidth = collectionView.frame.width
        let maxHeight = collectionView.frame.height
        return CGSize(width: maxWidth * 0.90, height: maxHeight / 4)
//        return CGSize(width: maxWidth * 0.90, height: label.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
extension FAQViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FAQs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FAQCell", for: indexPath) as? FAQCollectionViewCell else {
            fatalError("Failed to dequeue FAQCollectionViewCell")
        }
        let faq = FAQs[indexPath.row]
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.configureCell(faq: faq, userInfo: nil)
        return cell
    }
    
    
    
    
}
