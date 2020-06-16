//
//  PlayerListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit


protocol GameDataDelegate {
    func didGameUpdated(game: Game)
    func addNewGame(game: Game)
}

class PlayerListVC: UIViewController {
    
    var gameDataDelegate: GameDataDelegate!
    
    var game: Game!
    
    let tableView = UITableView()
    
    var highestScores = [0,0,0]
    var rankIndex = [0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = game?.title
        configureTableView()
        configureNavController()
    }
    
    func configureNavController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chart", style: .plain, target: self, action: #selector(chartTapped))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 20) ?? UIFont.systemFont(ofSize: 24)]
    }
    
    
    func configureTableView() {
        setTableViewDelegates()
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.register(UpdateCell.self, forCellReuseIdentifier: "UpdateCell")
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func chartTapped() {
        let chartVC = ChartVC()
        chartVC.players = game.players
        navigationController?.pushViewController(chartVC, animated: true)
    }
}

extension PlayerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return game?.players.count ?? 0
    }


    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerHeight:CGFloat = 20.0
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: footerHeight).isActive = true
        return view
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as? UpdateCell {
                cell.selectionStyle = .none
                cell.updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)

                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell{
            cell.selectionStyle = .none
            cell.playerNameLabel.text = game.players[indexPath.row].name
            cell.totalPointsLabel.text = "\(game.players[indexPath.row].pastPoints.last! )"
            
            let text = "★"
            var attr = [NSAttributedString.Key: Any]()
            
            switch game.players[indexPath.row].pastRanks.last! {
            case 1:
                attr = [.foregroundColor: UIColor.gold, .font: UIFont.systemFont(ofSize: 24)]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            case 2:
                attr = [.foregroundColor: UIColor.silver, .font: UIFont.systemFont(ofSize: 24)]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            case 3:
                attr = [.foregroundColor: UIColor.bronze, .font: UIFont.systemFont(ofSize: 24)]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            default:
                cell.starLabel.attributedText = nil
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func updateTapped() {
        var playersArray = [Player]()
        
        for i in 0..<game.players.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PlayerCell {
                game.players[i].pastPoints.append(game.players[i].pastPoints.last! + cell.addingPoint)
                cell.addingPoint = 0
                playersArray.append(game.players[i])

            }
        }
        
        let sortedPlayers = playersArray.sorted(by: {$0.pastPoints.last! > $1.pastPoints.last!})
        
        for (i, player) in sortedPlayers.enumerated() {
            player.pastRanks.append(i+1)
        }

        gameDataDelegate.didGameUpdated(game: game)
        tableView.reloadData()
    }
    
}
