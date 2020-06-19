//
//  GameListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia   

class GameListVC: UIViewController {

    let gameNames = ["card", "poker", "smashBroz"]
    let numPlayers = [4, 3, 5]
    let tableView = UITableView()
    var games = [Game]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews {
            tableView
        }
        setNavController()
        loadGames()
        configureTableView()
    }
    
    func loadGames() {
        let defaults = UserDefaults.standard
        
        if let savedGames = defaults.object(forKey: "games") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                games = try jsonDecoder.decode([Game].self, from: savedGames)
            } catch {
                print("Failed to load images")
            }
        }
    }
    
    func setNavController() {
        self.title = "List of Games"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.myBoldSystemFont(ofSize: 20)]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGameTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Top", style: .plain, target: self, action: #selector(backToTop))
    }
    
    @objc func backToTop() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        tableView.rowHeight = 80
        tableView.register(GameCell.self, forCellReuseIdentifier: "GameCell")
        tableView.height(100%).width(100%).top(0).left(0)
        tableView.backgroundColor = UIColor.backgroundColor
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension GameListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameCell {
            cell.gameNameLabel.text = games[indexPath.row].title
//            cell.gameNameLabel.textColor = .darkGray
            cell.playerLabel.text = "\(games[indexPath.row].players.count) players"
            cell.playerLabel.textColor = .gray
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = PlayerListVC()
        VC.gameDataDelegate = self
        VC.game = games[indexPath.row]
        games.remove(at: indexPath.row)
        games.insert(VC.game, at: 0)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){
            [weak self] (action, view, nil) in
            self?.games.remove(at: indexPath.row)
            self?.tableView.reloadData()
            self?.save()
        }
        delete.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    
    @objc func addNewGameTapped() {
        let VC = NewGameVC()
        VC.gameDataDelegate = self
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(games) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "games")
        } else {
            print("Failed to save games.")
        }
    }
}


extension GameListVC: GameDataDelegate {
    func didGameUpdated(game: Game) {
        games[0] = game
        save()
        self.tableView.reloadData()
    }
    
    func addNewGame(game: Game) {
        games.insert(game, at: 0)
        save()
        self.tableView.reloadData()
    }
}

