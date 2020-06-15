//
//  InterviewEntryView.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class InterviewEntryView: UIView {
    
    public var thankYouSent: Bool = false {
        didSet {
            if thankYouSent {
                thankYouButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                thankYouButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
    
    public var date: Date? = nil
    
    private let datePicker = UIDatePicker()
    
    public var hasInterviewData: Bool = false // should be made positive when interview is added 
    
    
    public lazy var dateTextField: UITextField = {
        let textfield = UITextField()
        textfield.setPadding()
        textfield.setBottomBorder()
        textfield.clearButtonMode = .always
        textfield.placeholder = "Interview date"
        return textfield
    }()
    
    public lazy var thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you note sent?"
        return label
    }()
    
    public lazy var thankYouButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square")
        button.tintColor = .black
        button.setImage(image, for: .normal)
        return button
    }()
    
    public lazy var notesTextField: UITextField = {
        let textfield = UITextField()
        textfield.setPadding()
        textfield.setBottomBorder()
        textfield.clearButtonMode = .always
        textfield.placeholder = "Interview notes"
        return textfield
    }()
    
    public lazy var deleteButton: UIButton = {
           let button = UIButton()
           let image = UIImage(systemName: "x.circle.fill")
           button.tintColor = .black
           button.setImage(image, for: .normal)
           return button
       }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
      //  backgroundColor = .systemGroupedBackground
    }
    
    private func commonInit() {
        constrainDateTextField()
        constrainNotesTextField()
        constainThankyouButton()
        constrainDeleteButton()
        constrainThankYouLabel()
        createDatePicker()
        thankYouButton.addTarget(self, action: #selector(toggleThankYou), for: .touchUpInside)
    }
    
    @objc private func toggleThankYou() {
        thankYouSent.toggle()
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        // assign toolbar
        dateTextField.inputAccessoryView = toolbar
        
        // assign date picker to text feild
        dateTextField.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonPressed() {
        dateTextField.text = "\(datePicker.date.dateString("MM/dd/yyyy"))"
        date = datePicker.date
        endEditing(true)
    }
    
    private func constrainDateTextField() {
        addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            dateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func constrainNotesTextField() {
        addSubview(notesTextField)
        notesTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notesTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 10),
            notesTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notesTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
    
    private func constainThankyouButton() {
        addSubview(thankYouButton)
        thankYouButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouButton.widthAnchor.constraint(equalToConstant: 44),
            thankYouButton.topAnchor.constraint(equalTo: notesTextField.bottomAnchor, constant: 10),
            thankYouButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            thankYouButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func constrainDeleteButton() {
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalTo: thankYouButton.heightAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteButton.topAnchor.constraint(equalTo: notesTextField.bottomAnchor, constant: 10)
        ])
    }
    
    private func constrainThankYouLabel() {
        addSubview(thankYouLabel)
        thankYouLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouLabel.topAnchor.constraint(equalTo: notesTextField.bottomAnchor, constant: 10),
            thankYouLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor
            ),
            thankYouLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            thankYouLabel.leadingAnchor.constraint(equalTo: thankYouButton.trailingAnchor, constant: 20)
        ])
    }
}
