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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.backgroundColor

        subviews {
            gameNameLabel
            playerLabel
        }
        
        configureGameNameLabel()
        configurePlayerLabel()
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
        playerLabel.numberOfLines = 0
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.height(60%).left(60%).centerVertically().width(20%)
    }
    
}
