//
//  PlayerCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class PlayerCell: UITableViewCell {

    var playerNameLabel = UILabel()
    var starLabel = UILabel()
    var totalPointsLabel = UILabel()
    var minusButton = SmallButton()
    var plusButton = SmallButton()
    var pointField = UITextField()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        
        subviews {
            playerNameLabel
            starLabel
            totalPointsLabel
            plusButton
            minusButton
            pointField
        }
        
        configurePlayerNameLabel()
        configureStarLabel()
        configureTotalPointsLabel()
        configureMinusButton()
        configurePlusButton()
        configurePointField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10))

    }
    
    func configureCell() {
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
    
    func configurePlayerNameLabel()  {
        playerNameLabel.numberOfLines = 0
        playerNameLabel.height(60%).centerVertically().width(25%).left(20)
    }
    
    func configureStarLabel() {
        starLabel.heightEqualsWidth().height(30%).centerVertically().left(30%)
    }
    
    func configureTotalPointsLabel() {
        totalPointsLabel.adjustsFontSizeToFitWidth = true
        totalPointsLabel.height(60%).centerVertically().width(15%).left(45%)
    }

    func configureMinusButton() {
        minusButton.heightEqualsWidth().centerVertically().width(10%).left(58%)
        minusButton.layer.cornerRadius = self.frame.size.width*0.04
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.myBoldSystemFont(ofSize: 26)]
        minusButton.setAttributedTitle(NSAttributedString(string: "-", attributes: attr), for: .normal)
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor.whiteGray.cgColor
    }
    
    func configurePlusButton() {
        plusButton.heightEqualsWidth().centerVertically().width(10%).left(88%)
        plusButton.layer.cornerRadius = self.frame.size.width*0.04
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.myBoldSystemFont(ofSize: 24)]
        plusButton.setAttributedTitle(NSAttributedString(string: "+", attributes: attr), for: .normal)
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.whiteGray.cgColor
    }
    
    func configurePointField() {
        pointField.placeholder = "0"
        pointField.textColor = .gray
        pointField.textAlignment = .center
        pointField.backgroundColor = .white
        pointField.keyboardType = .numberPad
        pointField.layer.borderWidth = 1
        pointField.layer.borderColor = UIColor.lightGray.cgColor
        setExitterForPointField()
        pointField.height(50%).centerVertically().width(14%).left(71%)
    }
    
    
    func setExitterForPointField() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: 100, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        pointField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        superview?.endEditing(true)
    }

}
