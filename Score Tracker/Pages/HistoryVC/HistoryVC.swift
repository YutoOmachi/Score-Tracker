//
//  HistoryVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 22/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HistoryVC: UIViewController {
    
    let tableView = UITableView()
    var game: Game!
    var gameDataDelegate: GameDataDelegate?

    let helpVC = HelpVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        
        view.subviews {
            tableView
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(displayHelp))

        configureTableView()
        setHelpVC()
    }
    
    func configureTableView() {
        tableView.height(100%).width(100%).left(0).top(0)
        tableView.backgroundColor = .backgroundColor
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "history")
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setHelpVC() {
        helpVC.closeButton.addTarget(self, action: #selector(closeHelp), for: .touchUpInside)
        helpVC.modalPresentationStyle = .fullScreen
        let imagePath = Bundle.main.path(forResource: "HistoryVC_HelpImage\(RESOLUTION)", ofType: "png")
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

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players[0].pastPoints.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as? HistoryCell{
            cell.numCol = game.players.count
            
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
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.height(tableView.rowHeight).width(100%)
        
        let width: Double = Double(100)/Double(game.players.count+1)
        var currLeft: Double = 0.01
        
        for i in 0...game.players.count {
            let label = UILabel()
            view.subviews {
                label
            }
            label.height(100%).centerVertically().left((currLeft)%).width((width)%)
            currLeft += width
            label.textAlignment = .center
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 0.5
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            label.backgroundColor = UIColor.navigationColor.withAlphaComponent(0.5)
            if i != 0 {
                let text = game.players[i-1].name
                let attr: [NSAttributedString.Key: Any] = [
                    .font: UIFont.mySystemFont(ofSize: 18),
                    .foregroundColor: UIColor.white,
                    .strokeColor: UIColor.white,
                    .strokeWidth: -1
                ]
                let attributedString = NSAttributedString(string: text, attributes: attr)
                label.attributedText = attributedString
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){
            [weak self] (action, view, nil) in
            self?.deleteTapped(row: indexPath.row)
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func deleteTapped(row: Int) {
        let ac = UIAlertController(title: "Delete this round?", message: "Once deleted, the score can't be restored", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){ [weak self] _ in
            self?.updatePastRecords(row: row)
            self?.tableView.reloadData()
            self?.gameDataDelegate?.saveGame()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func updatePastRecords(row: Int) {
        
        var playersArray = [Player]()
        //Delete the designated round score and Update all the scores
        for i in 0..<game.players.count {
            playersArray.append(game.players[i])
            
            //If deleting first round
            if row == 0 {
                if game.players[i].pastRanks.count == 1 {
                    game.players[i].pastPoints.remove(at: 0)
                }
                else {
                    let score =  game.players[i].pastPoints[0]
                    game.players[i].pastPoints.remove(at: 0)
                    for j in 0..<game.players[i].pastPoints.count {
                        game.players[i].pastPoints[j] -= score
                    }
                }
            }
            
            else {
                let score =  game.players[i].pastPoints[row] - game.players[i].pastPoints[row-1]
//                print("Deleted Score: \(score)")
                game.players[i].pastPoints.remove(at: row)
                for j in row..<game.players[i].pastPoints.count {
                    game.players[i].pastPoints[j] -= score
                }
            }
            
            let lastIndex = game.players[i].pastRanks.count
            game.players[i].pastRanks.remove(at: lastIndex - 1)
        }
                
        //Update all the ranks
        for round in row..<game.players[0].pastPoints.count {
            playersArray.sort(by: {$0.pastPoints[round] > $1.pastPoints[round]})
            for (i, player) in playersArray.enumerated() {
                player.pastRanks[round] =  i+1
            }
        }
        
        tableView.reloadData()
    }
}
