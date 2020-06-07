//
//  GameCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    var gameNameLabel = UILabel()
    var playerLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(gameNameLabel)
        addSubview(playerLabel)
        
        configureGameNameLabel()
        configurePlayerLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    func configureGameNameLabel() {
        gameNameLabel.numberOfLines = 0
        gameNameLabel.adjustsFontSizeToFitWidth = true
        setGameNameLabelConstraints()
    }
    
    func configurePlayerLabel() {
        playerLabel.numberOfLines = 0
        playerLabel.adjustsFontSizeToFitWidth = true
        setPlayerLabelConstraints()
    }
    
    func setGameNameLabelConstraints() {
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            gameNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            gameNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            gameNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setPlayerLabelConstraints() {
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            playerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            playerLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 0),
            playerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}
