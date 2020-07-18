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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setCollectionView()
        setCollectionView()
    }
    
    func setCollectionView() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(WelcomeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isPagingEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .green
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension WelcomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
