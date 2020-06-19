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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundColor
        
        subviews {
            updateButton
        }
        configureUpdateButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    func configureUpdateButton() {
        let text = "Update"
        let attr: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white
        ]
        let attrString = NSAttributedString(string: text, attributes: attr)
        updateButton.setAttributedTitle(attrString, for: .normal)
        
        updateButton.backgroundColor = UIColor.cellColor
        updateButton.layer.cornerRadius = 40
        
        updateButton.height(80%).width(40%).centerVertically().centerHorizontally()
    }

    
}
