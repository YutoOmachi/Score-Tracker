//
//  HelpVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 12/7/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HelpVC: UIViewController {

    let closeButton = UIButton(type: .close)
    let helpView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setConstraints()   
        setHelpView()
    }
    
    func setViewController() {
        self.view.backgroundColor = .clear
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .formSheet
    }
    
    func setHelpView() {
        helpView.contentMode = .scaleAspectFit
        helpView.alpha = 0.0
    }
    
    func setConstraints() {
        view.subviews {
            closeButton
            helpView
        }
        helpView.bottom(5%).centerHorizontally().width(80%).height(80%)
        closeButton.top(10%).right(10%).width(15%).heightEqualsWidth()
    }
    
}

