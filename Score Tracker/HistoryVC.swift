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
    var players = ["Aya", "Sara", "Tomo", "Ted", "Yuto", "Abrakadabra SesamiStreet"]
    var gameScore = [[0,4,0,1,0,0],[0,0,0,2,0,1],[1,0,0,0,0,1],[0,0,0,2,0,1],[0,0,0,2,0,1],[0,0,0,2,0,1]]
    
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
        return gameScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as? HistoryCell{
            cell.numCol = players.count
            cell.labels[0].text = "\(indexPath.row+1)"
            for (i, label) in cell.labels.enumerated() {
                if i != 0 {
                    label.text = "\(gameScore[indexPath.row][i-1])"
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.height(tableView.rowHeight).width(100%)
        view.backgroundColor = .cellColor
        
        let width: Double = Double(100)/Double(players.count+1)
        var currLeft: Double = 0.01
        
        for i in 0...players.count {
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
                label.text = players[i-1]
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){
            [weak self] (action, view, nil) in
            self?.deleteTapped(indexPath: indexPath)
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func deleteTapped(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete this round?", message: "Once you deleted, the score cannot be restored", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){ [weak self] _ in
            self?.gameScore.remove(at: indexPath.row)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}
