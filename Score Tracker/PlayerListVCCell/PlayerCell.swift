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
    
    func configureCell() {
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.cellColor.cgColor
        self.backgroundColor = .backgroundColor
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
        totalPointsLabel.height(60%).centerVertically().width(15%).left(50%)
    }

    func configureMinusButton() {
        minusButton.addTarget(self, action: #selector(minusOnePoint), for: .touchUpInside)
        minusButton.heightEqualsWidth().centerVertically().width(8%).left(65%)
        minusButton.layer.cornerRadius = self.frame.size.width*0.04
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.myBoldSystemFont(ofSize: 24)]
        minusButton.setAttributedTitle(NSAttributedString(string: "-", attributes: attr), for: .normal)
    }
    
    func configurePlusButton() {
        plusButton.addTarget(self, action: #selector(plusOnePoint), for: .touchUpInside)
        plusButton.heightEqualsWidth().centerVertically().width(8%).left(87%)
        plusButton.layer.cornerRadius = self.frame.size.width*0.04
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont.myBoldSystemFont(ofSize: 20)]
        plusButton.setAttributedTitle(NSAttributedString(string: "+", attributes: attr), for: .normal)
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
        pointField.height(50%).centerVertically().width(10%).left(75%)
    }
    
    
    @objc func plusOnePoint(sender: UIButton) {
        if let addPoint = pointField.text {
            pointField.text = "\((Int(addPoint) ?? 0) + 1)"
        }
    }
    
    @objc func minusOnePoint(sender: UIButton) {
        if let addPoint = pointField.text {
            pointField.text = "\((Int(addPoint) ?? 0) - 1)"
        }
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
