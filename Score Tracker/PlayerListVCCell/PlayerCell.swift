//
//  PlayerCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit


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
        
        addSubview(playerNameLabel)
        addSubview(starLabel)
        addSubview(totalPointsLabel)
        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(pointField)
        
        configurePlayerNameLabel()
        configureStarLabel()
        configureTotalPointsLabel()
        configurePlusMinusLabel()
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
        setPlayerNameLabelConstraints()
    }
    
    func configureStarLabel() {
        setStarLabelConstraints()
    }
    
    func configureTotalPointsLabel() {
        totalPointsLabel.adjustsFontSizeToFitWidth = true
        setTotalPointsLabelConstraints()
    }

    func configurePlusMinusLabel() {
        plusButton.setTitle("+", for: .normal)
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        plusButton.addTarget(self, action: #selector(plusOnePoint), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusOnePoint), for: .touchUpInside)
        setPlusMinusConstraints()
    }
    
    func configurePointField() {
        pointField.adjustsFontSizeToFitWidth = true
        pointField.textAlignment = .center
        pointField.backgroundColor = .white
        addingPoint = 0
        pointField.keyboardType = .numberPad
        pointField.addTarget(self, action: #selector(pointFieldDidChange), for: .editingChanged)
        setExitterForPointField()
        setPointFieldConstraints()
    }
    
    func setPlayerNameLabelConstraints()  {
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playerNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            playerNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            playerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setStarLabelConstraints() {
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            starLabel.widthAnchor.constraint(equalTo: starLabel.heightAnchor),
            starLabel.leadingAnchor.constraint(equalTo: playerNameLabel.trailingAnchor)
        ])
    }
    
    func setTotalPointsLabelConstraints()  {
        totalPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            totalPointsLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            totalPointsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            totalPointsLabel.leadingAnchor.constraint(equalTo: starLabel.trailingAnchor, constant: 30)
        ])
    }
    
    func setPlusMinusConstraints()  {
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            plusButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            minusButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
            minusButton.trailingAnchor.constraint(equalTo: pointField.leadingAnchor, constant: -10)
        ])
    }
    
    func setPointFieldConstraints()  {
        pointField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pointField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pointField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            pointField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
            pointField.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -10)
        ])
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
