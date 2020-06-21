//
//  GameCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class GameCell: UITableViewCell {

    var gameNameLabel = UILabel()
    var playerLabel = UILabel()
    var lastEdittedLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.backgroundColor

        subviews {
            gameNameLabel
            playerLabel
            lastEdittedLable
        }
        
        configureGameNameLabel()
        configurePlayerLabel()
        configureLastEdittedLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    func configureGameNameLabel() {
        gameNameLabel.numberOfLines = 0
        gameNameLabel.adjustsFontSizeToFitWidth = true
        gameNameLabel.height(80%).left(10%).centerVertically().width(40%)
    }
    
    func configurePlayerLabel() {
        playerLabel.numberOfLines = 1
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.textColor = .gray
        playerLabel.height(30%).left(60%).top(15%).width(20%)
    }
    
    func configureLastEdittedLabel() {
        lastEdittedLable.numberOfLines = 1
        lastEdittedLable.adjustsFontSizeToFitWidth = true
        lastEdittedLable.textColor = .gray
        lastEdittedLable.height(30%).left(60%).top(55%).width(20%)
    }
    
}
