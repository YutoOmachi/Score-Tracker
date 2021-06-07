//
//  HistoryHorizontalScrollCell.swift
//  Score Tracker
//
//  Created by Yuto Omachi on 2021-02-19.
//  Copyright © 2021 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HistoryHorizontalScrollCell: UICollectionViewCell {
    
    var numCol: Int? {
        didSet {
            if labels.isEmpty {
                for i in 0...(numCol ?? 0) {
                    let label = UILabel()
                    label.tag = i+10
                    contentView.subviews {
                        label
                    }
                    labels.append(label)
                    label.insetsLayoutMarginsFromSafeArea = false
                }
                configureLabels()
            }
        }
    }
    
    var labels = [UILabel]()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureLabels() {
        var height: Double = Double(100)/Double(labels.count)
        height = height > 20 ? 20 : height

        for (i, label) in labels.enumerated() {
            if i == 0 {label.width(100%).left(0).top(0).height((height)%)}
            else {label.width(100%).left(0).top((height*Double(i))%).height((height)%)}
            label.textAlignment = .center
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 0.5
            
            if label.tag == 10 {
                label.backgroundColor = UIColor.whiteGray.withAlphaComponent(0.8)
            }
        }
    }
}

