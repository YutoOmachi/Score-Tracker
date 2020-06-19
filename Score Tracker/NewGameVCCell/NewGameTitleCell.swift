//
//  NewGameTitleCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 13/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class NewGameTitleCell: UITableViewCell {
    var titleField = UITextField()

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .backgroundColor
        self.subviews {
            titleField
        }
        configureTitleField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
       
    func configureTitleField() {
        titleField.height(60%).width(60%).centerHorizontally().centerVertically()
        titleField.placeholder = "Game Title"
        titleField.textAlignment = .center
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.lightGray.cgColor
        titleField.autocorrectionType = .no
    }

}
