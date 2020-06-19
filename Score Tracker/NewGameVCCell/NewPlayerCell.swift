//
//  NewPlayerCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 13/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class NewPlayerCell: UITableViewCell {
    var colorButton = SmallButton()
    var nameLabel = UILabel()
    var nameField = UITextField()
    var handicapLabel = UILabel()
    var handicapField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.backgroundColor

        self.subviews {
            colorButton
            nameLabel
            nameField
            handicapLabel
            handicapField
        }
        configureColorButton()
        configureNameLabel()
        configureNameField()
//        configureHandicapLabel()
//        configureHandicapField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    func configureColorButton() {
        colorButton.height(self.frame.size.height/1.5).centerVertically().width(self.frame.size.height/1.5).left(5%)
        colorButton.layer.cornerRadius = self.frame.size.height/3
    }
    
    func configureNameLabel() {
        nameLabel.height(20%).top(10%).width(40%).left(20%)
        nameLabel.text = "Player Name"
        nameLabel.textColor = UIColor.gray
    }
    
    func configureNameField() {
        nameField.height(40%).top(40%).width(40%).left(20%)
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.textAlignment = .center
        nameField.autocorrectionType = .no
        setExitterForNameField()
    }
    
    func configureHandicapLabel() {
        handicapLabel.height(20%).top(10%).width(20%).left(70%)
        handicapLabel.text = "Handicap"
        handicapLabel.textColor = UIColor.gray
    }
    
    func configureHandicapField() {
        handicapField.height(40%).top(40%).width(20%).left(70%)
        handicapField.layer.borderWidth = 1
        handicapField.layer.borderColor = UIColor.lightGray.cgColor
        handicapField.textAlignment = .center
        handicapField.keyboardType = .numberPad
    }

    func setExitterForNameField() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: 100, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        nameField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        superview?.endEditing(true)
    }
}