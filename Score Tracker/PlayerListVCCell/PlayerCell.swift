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
    var minusButton = UIButton()
    var plusButton = UIButton()
    var pointField = UITextField()
    
    var addingPoint:Int = 0 {
        didSet {
            pointField.text = "\(addingPoint)"
        }
    }
        
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
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.cellColor.cgColor
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
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        minusButton.addTarget(self, action: #selector(minusOnePoint), for: .touchUpInside)
        minusButton.heightEqualsWidth().centerVertically().width(8%).left(65%)
        minusButton.layer.cornerRadius = self.frame.size.width*0.04
        minusButton.layer.backgroundColor = UIColor.cyan.cgColor
    }
    
    func configurePlusButton() {
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.addTarget(self, action: #selector(plusOnePoint), for: .touchUpInside)
        plusButton.heightEqualsWidth().centerVertically().width(8%).left(87%)
        plusButton.layer.cornerRadius = self.frame.size.width*0.04
        plusButton.layer.backgroundColor = UIColor.cyan.cgColor
    }
    
    func configurePointField() {
        pointField.adjustsFontSizeToFitWidth = true
        pointField.textAlignment = .center
        pointField.backgroundColor = .white
        addingPoint = 0
        pointField.keyboardType = .numberPad
        pointField.layer.borderWidth = 1
        pointField.layer.borderColor = UIColor.lightGray.cgColor
        pointField.addTarget(self, action: #selector(pointFieldDidChange), for: .editingChanged)
        setExitterForPointField()
        pointField.height(50%).centerVertically().width(10%).left(75%)
    }
    
    
    @objc func plusOnePoint(sender: UIButton) {
        addingPoint += 1
    }
    
    @objc func minusOnePoint(sender: UIButton) {
        addingPoint -= 1
    }
    
    @objc func pointFieldDidChange() {
        if let newPoint = pointField.text {
            addingPoint = Int(newPoint) ?? addingPoint
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
