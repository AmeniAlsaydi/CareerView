//
//  FAQViewController.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    //MARK:- Variables
    private var FAQs = [FAQInfo]()
    //MARK:- ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureCollectionView()
        loadFAQInfo()
    }
    //MARK:- Functions
    private func configureNavBar() {
        navigationItem.title = "FAQs"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BasicInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basicInfoCell")
        if let flowLayout = collectionViewLayout,
            let collectionView = collectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
    }
    private func loadFAQInfo() {
        FAQs = FAQInfo.loadFAQs()
    }
}
//MARK:- Extensions
extension FAQViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let faq = FAQs[indexPath.row]
        let label = UILabel(frame: CGRect.zero)
        label.text = faq.description
        label.sizeToFit()
        let maxWidth = collectionView.frame.width
        let maxHeight = collectionView.frame.height
        return CGSize(width: maxWidth * 0.90, height: maxHeight / 4)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicInfoCell", for: indexPath) as? BasicInfoCollectionViewCell else {
            fatalError("Failed to dequeue basicInfoCell")
        }
        let faq = FAQs[indexPath.row]
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.configureCell(faq: faq, userInfo: nil)
        return cell
    }
}
