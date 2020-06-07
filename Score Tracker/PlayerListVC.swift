//
//  PlayerListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class PlayerListVC: UIViewController {
    
    let names = ["Player1", "Player2", "Player3", "Player4"]
    let score = [12, 16, 73, 45]
    
    var game: Game?
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    func configureTableView() {
        setTableViewDelegates()
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension PlayerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game?.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell{
            cell.playerNameLabel.text = game?.players[indexPath.row].name
            cell.totalPointsLabel.text = "\(game?.players[indexPath.row].pastPoints.last! ?? 0)"
            return cell
        }
        return UITableViewCell()
    }
    
    
}
