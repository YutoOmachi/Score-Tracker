//
//  Player.swift
//  Score Tracker
//
//  Created by 小町悠登 on 7/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit


class Player: NSObject, Codable {
    var name: String
    var pastRanks = [1]
    var pastPoints = [0]
    var color:[CGFloat]
    
    init(name: String, color: [CGFloat]) {
        self.name = name
        self.color = color
    }
}
