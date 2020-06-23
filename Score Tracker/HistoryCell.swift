//
//  HistoryCell.swift
//  Score Tracker
//
//  Created by 小町悠登 on 22/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HistoryCell: UITableViewCell {
    
    var numCol: Int? {
        didSet {
            if labels.isEmpty {
                for i in 0...(numCol ?? 0) {
                    let label = UILabel()
                    label.tag = i+10
                    addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    labels.append(label)
                }
                
                configureLabels()
            }
        }
    }
    
    var labels = [UILabel]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.backgroundColor
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureLabels() {
        let width: Double = Double(100)/Double(labels.count)
        var currLeft: Double = 0.01

        for label in labels {
            label.height(100%).centerVertically().left((currLeft)%).width((width)%)
            currLeft += width
            label.textAlignment = .center
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 0.5
            
            if label.tag == 10 {
                label.backgroundColor = .cellColor
            }
        }
    }
}
