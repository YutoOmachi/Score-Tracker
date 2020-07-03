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
    var color: UIColor? {
        didSet {
            colorButton.backgroundColor = color
        }
    }
    var colorButton = SmallButton()
    var nameLabel = UILabel()
    var nameField = UITextField()
    var handicapLabel = UILabel()
    var handicapField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCell()
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10))
    }
    
    func configureCell() {
        self.selectionStyle = .none
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius  = 2
        layer.shadowOpacity = 0.2
        clipsToBounds       = false
        layer.shadowColor = UIColor.black.cgColor
        
        // add corner radius on `contentView`
        let size = layer.frame.size
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = size.width*0.1
    }
    
    func configureColorButton() {
        colorButton.height(self.frame.size.height/1.2).centerVertically().width(self.frame.size.height/1.2).left(10%)
        colorButton.layer.cornerRadius = self.frame.size.height/2.4
        colorButton.backgroundColor = color 
    }
    
    func configureNameLabel() {
        nameLabel.height(20%).top(10%).width(40%).left(35%)
        nameLabel.text = "Player Name"
        nameLabel.textColor = UIColor.gray
    }
    
    func configureNameField() {
        nameField.height(40%).top(40%).width(40%).left(35%)
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.textAlignment = .center
        nameField.autocorrectionType = .no
        setExitterForNameField()
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
