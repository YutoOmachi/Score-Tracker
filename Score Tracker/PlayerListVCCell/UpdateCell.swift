//
//  UpdateCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 8/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class UpdateCell: UITableViewCell {
    var updateButton = LargeButton()
    var historyButton = LargeButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundColor
        
        subviews {
            updateButton
            historyButton
        }
        configureUpdateButton()
        configureHistoryButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    func configureUpdateButton() {
        updateButton.layer.cornerRadius = 40
        updateButton.height(80%).width(35%).left(55%).centerVertically()
        
        let text = "Update"
        updateButton.backgroundColor = UIColor.cellColor
        
        let attr: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.myBoldSystemFont(ofSize: 22)
        ]
        let attrString = NSAttributedString(string: text, attributes: attr)
        updateButton.setAttributedTitle(attrString, for: .normal)
    }

    func configureHistoryButton() {
        historyButton.layer.cornerRadius = 40
        historyButton.height(80%).width(35%).left(10%).centerVertically()
        
        let text = "History"
        historyButton.backgroundColor = .gray
        
        let attr: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.myBoldSystemFont(ofSize: 22)
        ]
        let attrString = NSAttributedString(string: text, attributes: attr)
        historyButton.setAttributedTitle(attrString, for: .normal)
    }
}
