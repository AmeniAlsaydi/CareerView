//
//  ChildView.swift
//  Capstone
//
//  Created by casandra grullon on 6/3/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

protocol FilterStateDelegate: AnyObject {
    func didAddFilter(_ filterState: FilterState, child: FilterMenuViewController)
    func pressedCancel(child: FilterMenuViewController)
}

class FilterMenuViewController: UIViewController {
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var bookmarkedButton: UIButton!
    @IBOutlet weak var commonButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var setFilterButton: UIButton!
    
    public var filterState: FilterState? {
        didSet {
            updateUI()
        }
    }
    public weak var delegate: FilterStateDelegate?
    
    override func viewDidLoad() {
        updateUI()
    }
    private func updateUI() {
        if filterState == .all {
            allButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            bookmarkedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .bookmarked {
            bookmarkedButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .common {
            commonButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            bookmarkedButton.setImage(UIImage(systemName: "square"), for: .normal)
            customButton.setImage(UIImage(systemName: "square"), for: .normal)
        } else if filterState == .custom {
            customButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            allButton.setImage(UIImage(systemName: "square"), for: .normal)
            bookmarkedButton.setImage(UIImage(systemName: "square"), for: .normal)
            commonButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    //MARK:- IBAction functions
    @IBAction func allButtonPressed(_ sender: UIButton) {
        setFilterButton.isEnabled = true
        filterState = .all
    }
    @IBAction func savedButtonPressed(_ sender: UIButton){
        setFilterButton.isEnabled = true
        filterState = .bookmarked
    }
    @IBAction func commonButtonPressed(_ sender: UIButton) {
        setFilterButton.isEnabled = true
        filterState = .common
    }
    @IBAction func customButtonPressed(_ sender: UIButton) {
        setFilterButton.isEnabled = true
        filterState = .custom
    }
    @IBAction func setFilterButtonPressed(_ sender: UIButton) {
        guard let filter = filterState else {
            return
        }
        delegate?.didAddFilter(filter, child: self)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.pressedCancel(child: self)
    }
}
