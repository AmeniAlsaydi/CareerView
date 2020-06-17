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
        collectionView.delegate = self
        collectionView.dataSource = self
        loadFAQInfo()
    }
    private func loadFAQInfo() {
        FAQs = FAQInfo.loadFAQs()
    }
}
extension FAQViewController: UICollectionViewDelegate {
    
}
extension FAQViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FAQs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    

    
    
}
