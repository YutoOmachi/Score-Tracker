//
//  GameListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class GameListVC: UIViewController {

    let gameNames = ["card", "poker", "smashBroz"]
    let numPlayers = [4, 3, 5]
    let tableView = UITableView()
    var games = [Game]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura-Medium", size: 20) ?? UIFont.systemFont(ofSize: 24)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGameTapped))
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 80
        tableView.register(GameCell.self, forCellReuseIdentifier: "GameCell")
        tableView.pin(to: view)
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
            cell.playerLabel.text = "\(games[indexPath.row].players.count) players"
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

