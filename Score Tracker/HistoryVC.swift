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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.subviews {
            tableView
        }
        
        tableView.height(100%).width(100%).left(0).top(0)
        tableView.backgroundColor = .backgroundColor
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "history")
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.players[0].pastPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as? HistoryCell{
            cell.numCol = game.players.count
            cell.labels[0].text = "\(indexPath.row+1)"
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
            
            if i != 0 {
                label.text = game.players[i-1].name
                label.backgroundColor = .cellColor
            }
            else {
                label.backgroundColor = .backgroundColor
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
        let ac = UIAlertController(title: "Delete this round?", message: "Once you deleted, the score cannot be restored", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){ [weak self] _ in
            self?.updatePastRecords(row: row)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func updatePastRecords(row: Int) {
        
        var playersArray = [Player]()
        //Delete the designated round score and Update all the scores
        for i in 0..<game.players.count {
//            print("points(before): \(game.players[i].pastPoints)")
//            print("ranks(before): \(game.players[i].pastRanks)")
            playersArray.append(game.players[i])
            
            //If deleting first round
            if row == 0 {
                if game.players[i].pastRanks.count == 1 {
                    game.players[i].pastPoints.remove(at: 0)
                }
                else {
                    let score =  game.players[i].pastPoints[0]
//                    print("Deleted Score: \(score)")
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
//            print("points(after): \(game.players[i].pastPoints)")
//            print("ranks(after): \(game.players[i].pastRanks)")
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
