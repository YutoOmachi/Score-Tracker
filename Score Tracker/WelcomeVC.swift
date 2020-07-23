//
//  WelcomeVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 18/7/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class WelcomeVC: UICollectionViewController {
    
    var numPages = 4
    
    var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .navigationColor
        return button
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = numPages
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        
        view.subviews {
            startButton
            pageControl
        }
        setConstraints()
    }
    
    func setCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(WelcomeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPages
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WelcomeCell else { return UICollectionViewCell() }
        
        switch indexPath.item {
        case 0:
            cell.imgView.image = UIImage(named: "Welcome1")
        case 1:
            cell.imgView.image = UIImage(named: "Welcome2")
        case 2:
            cell.imgView.image = UIImage(named: "Welcome3")
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x/view.frame.width)
    }
    
    func setConstraints() {
        startButton.left(10%).width(80%).bottom(5%).height(10%)
        startButton.setTitle("Start Now", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        pageControl.left(10%).width(80%).bottom(15%).height(10%)
    }
    
    @objc func startButtonTapped() {
        print("start button tapped")
    }

}

extension WelcomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
