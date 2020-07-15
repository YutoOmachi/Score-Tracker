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

    var closeButton = UIButton(type: .custom)
    let helpView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setConstraints()   
        setHelpView()
        configureButton()
    }
    
    func setViewController() {
        self.view.backgroundColor = .clear
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.isModalInPresentation = false
        self.helpView.backgroundColor = .red
    }
    
    func setHelpView() {
        helpView.contentMode = .scaleAspectFit
    }
    
    func setConstraints() {
        view.subviews {
            helpView
            closeButton
        }
        helpView.height(101%).width(101%).left(-2).top(-2)
        closeButton.top(5%).left(5%).width(10%).heightEqualsWidth()
    }
    
    func configureButton() {
        closeButton.backgroundColor = .lightGray
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
    }
    
}

