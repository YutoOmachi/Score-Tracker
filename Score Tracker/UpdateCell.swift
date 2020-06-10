//
//  UpdateCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 8/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class UpdateCell: UITableViewCell {
    var updateButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(updateButton)
        configureUpdateButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    func configureUpdateButton() {
        let text = "Update"
        let attr: [NSAttributedString.Key : Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]
        let attrString = NSAttributedString(string: text, attributes: attr)
        updateButton.setAttributedTitle(attrString, for: .normal)
        
        updateButton.backgroundColor = UIColor.cellColor
        updateButton.layer.cornerRadius = 40
        
        setUpdateButtonConstraints()    
    }
    
    func setUpdateButtonConstraints() {
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            updateButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            updateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            updateButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
