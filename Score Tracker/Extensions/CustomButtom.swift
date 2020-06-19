//
//  CustomButtom.swift
//  Score Tracker
//
//  Created by 小町悠登 on 16/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class SmallButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        titleLabel?.font = UIFont(name: "Future-Medium", size: 16)
        titleLabel?.textColor = UIColor.black
        layer.backgroundColor = UIColor.white.cgColor

//        layer.borderWidth    = 3.0
//        layer.borderColor    = UIColor.darkGray.cgColor
        setShadow()
    }
    
    func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 1
        layer.shadowOpacity = 0.2
        clipsToBounds       = true
        layer.masksToBounds = false
    }
}

class LargeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        titleLabel?.font = UIFont(name: "Future-Medium", size: 24)
        titleLabel?.textColor = UIColor.white
        layer.backgroundColor = UIColor.cellColor.cgColor
//        layer.borderWidth    = 3.0
//        layer.borderColor    = UIColor.darkGray.cgColor
        setShadow()
    }
    
    func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
}

