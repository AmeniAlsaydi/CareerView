//
//  ChildView.swift
//  Capstone
//
//  Created by casandra grullon on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol FilterStateDelegate: NSObject {
    func didAddFilter(_ filterState: FilterState, child: FilterMenuViewController)
    func pressedCancel(child: FilterMenuViewController)
}

class FilterMenuViewController: UIViewController {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    
    public var filterState: FilterState = .all
    public weak var delegate: FilterStateDelegate?
    
    override func viewDidLoad() {
        updateUI()
    }
    private func updateUI() {
        if filterState == .all {
            allButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .saved {
            savedButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .common {
            commonButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .custom {
            customButton.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            savedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    //MARK:- IBAction functions
    @IBAction func allButtonPressed(_ sender: UIButton) {
        filterState = .all
        
    }
    @IBAction func savedButtonPressed(_ sender: UIButton){
        filterState = .saved
    }
    @IBAction func commonButtonPressed(_ sender: UIButton) {
        filterState = .common
        updateUI()
    }
    @IBAction func customButtonPressed(_ sender: UIButton) {
        filterState = .custom
    }
    @IBAction func setFilterButtonPressed(_ sender: UIButton) {
        delegate?.didAddFilter(filterState, child: self)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.pressedCancel(child: self)
    }
}
