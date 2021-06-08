//
//  HistoryHorizontalScrollVC.swift
//  Score Tracker
//
//  Created by Yuto Omachi on 2021-02-19.
//  Copyright © 2021 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HistoryHorizontalScrollVC: UIViewController {
    
    let nameContainer = UIView()
    var historyView: UICollectionView!
    var game: Game!
    var gameDataDelegate: GameDataDelegate?
    let helpVC = HelpVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insetsLayoutMarginsFromSafeArea = false
        
        initCollectionView()
        configureCollectionView()
        initPlayerNamesLabel()
        setHelpVC()
        
        self.edgesForExtendedLayout = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action:  #selector(displayHelp))
    }

    
    func initPlayerNamesLabel() {
        view.subviews {
            nameContainer
        }
        nameContainer.width(20%).height(100%).left(0).top(0)
        nameContainer.backgroundColor = .backgroundColor
        
        var height: Double = Double(100)/Double(game.players.count+1)
        height = height > 20 ? 20 : height
        
        // Gray block at the top
        let grayBlock = UILabel()
        grayBlock.text = "(Round)"
        grayBlock.textAlignment = .center
        grayBlock.textColor = .white
        grayBlock.backgroundColor = UIColor.whiteGray.withAlphaComponent(0.8)
        grayBlock.layer.borderColor = UIColor.gray.cgColor
        grayBlock.layer.borderWidth = 0.5
        nameContainer.subviews{
            grayBlock
        }
        grayBlock.width(100%).left(0).top(0).height((height)%)

        
        // List of player names
        var currTop: Double = height 
        for player in game.players {
            let nameLabel = UILabel()
            
            nameContainer.subviews {
                nameLabel
            }
            nameLabel.width(100%).left(0).top((currTop)%).height((height)%)
            currTop += height
            
            
            nameLabel.text = "\(player.name)\n(Total:\(player.pastPoints.last ?? 0))"
            nameLabel.numberOfLines = 0
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.textAlignment = .center
            nameLabel.layer.borderColor = UIColor.gray.cgColor
            nameLabel.layer.borderWidth = 0.5
        }
    }
    
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        historyView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.subviews {
            historyView!
        }
        historyView.width(80%).height(100%).left(20%).top(0)
        // Don't allow automatic change in insets
        historyView.contentInsetAdjustmentBehavior = .never
    }
    
    func configureCollectionView() {
        historyView.backgroundColor = .backgroundColor
        historyView.register(HistoryHorizontalScrollCell.self, forCellWithReuseIdentifier: "cell")
        historyView.dataSource = self
        historyView.delegate = self
    }
    
    func setHelpVC() {
        helpVC.modalPresentationStyle = .fullScreen
        helpVC.closeButton.addTarget(self, action: #selector(closeHelp), for: .touchUpInside)
        let imagePath = Bundle.main.path(forResource: "HistoryHorizontalScrollVC_HelpImage\(RESOLUTION)", ofType: "png")
        let image = UIImage(contentsOfFile: imagePath!)
        helpVC.helpView.image = image
    }
    
    @objc func displayHelp() {
        helpVC.helpView.alpha = 0.0
        helpVC.closeButton.alpha = 0.0
        present(helpVC, animated: true) {
            UIView.animate(withDuration: 1, animations: {
                self.helpVC.helpView.alpha = 1.0
                self.helpVC.closeButton.alpha = 1.0
            })
        }
    }
    
    @objc func closeHelp() {
        helpVC.dismiss(animated: true)
    }
}


extension HistoryHorizontalScrollVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.players[0].pastPoints.count
    }
}

extension HistoryHorizontalScrollVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HistoryHorizontalScrollCell{
            cell.numCol = game.players.count
            cell.contentView.layoutIfNeeded()

            let text = "\(indexPath.row+1)"
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.myBoldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.white
            ]
            let attributedString = NSAttributedString(string: text, attributes: attr)
            cell.labels[0].attributedText = attributedString
            
            for (i, label) in cell.labels.enumerated() {
                if i != 0 {
                    if indexPath.row == 0 {
                        label.text = "\(game.players[i-1].pastPoints[indexPath.row])"
                    }
                    else {
                        label.text = "\(game.players[i-1].pastPoints[indexPath.row] - game.players[i-1].pastPoints[indexPath.row-1])"
                    }
                }
            }
            cell.insetsLayoutMarginsFromSafeArea = false
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension HistoryHorizontalScrollVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height)
    }
}





