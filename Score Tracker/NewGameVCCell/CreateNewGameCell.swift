//
//  CreateNewGameCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 13/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class CreateNewGameCell: UITableViewCell {
    var createNewGameButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.subviews {
            createNewGameButton
        }
        configureUpdateButton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(code) is not implemented")
    }
    
    func configureUpdateButton() {
        let text = "Create New Game"
        let attr: [NSAttributedString.Key : Any] = [
            .font: UIFont.titleFont,
            .foregroundColor: UIColor.white
        ]
        let attrString = NSAttributedString(string: text, attributes: attr)
        createNewGameButton.setAttributedTitle(attrString, for: .normal)
        
        createNewGameButton.backgroundColor = UIColor.cellColor
        
        createNewGameButton.centerHorizontally().centerVertically().height(80%).width(50%)
    }
}
