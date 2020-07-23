//
//  WelcomeCellCollectionViewCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 18/7/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class WelcomeCell: UICollectionViewCell {
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.subviews{
            imgView
        }
        imgView.size(100%)
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    }
}
