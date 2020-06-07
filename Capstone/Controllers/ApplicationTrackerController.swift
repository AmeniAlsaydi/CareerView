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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        collectionView.backgroundView = EmptyView(title: "hello", message: "test", imageName: "mic")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    


}

extension ApplicationTrackerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}


extension ApplicationTrackerController: UICollectionViewDelegateFlowLayout {
    
    // height and width
    
}
