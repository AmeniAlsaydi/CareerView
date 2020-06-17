//
//  FAQCollectionViewCell.swift
//  Capstone
//
//  Created by Gregory Keeley on 6/16/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FAQCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    public func configureCell(faq: FAQInfo) {
        titleLabel.text = faq.title
        answerLabel.text = faq.description
    }
}
