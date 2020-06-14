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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGame))
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
    
    
    @objc func addNewGame() {
        addTitle()
    }
    
    @objc func addTitle() {
        let ac = UIAlertController(title: "Title", message: "Enter the name of the game", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){[weak self] _ in
            if let titleText = ac.textFields?[0].text {
                self?.games.insert(Game(title: titleText), at: 0)
                self?.addPlayer()
            }
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func addPlayer() {
        let ac = UIAlertController(title: "Add a player", message: "Enter the name of a player", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add more players", style: .default){[weak self] _ in
            if let playerName = ac.textFields?[0].text {
                if !playerName.isEmpty{
                    self?.games[0].players.append(Player(name: playerName))
                }
            }
            self?.addPlayer()
        })
        ac.addAction(UIAlertAction(title: "Make Game!", style: .default){[weak self] _ in
            if let playerName = ac.textFields?[0].text {
                if !playerName.isEmpty{
                    self?.games[0].players.append(Player(name: playerName))
                }
            }
            
            if self?.games[0].players.count ?? 0 < 1 {
                self?.errorNotEnoughPlayers()
                return
            }
            
            self?.save()
            let VC = PlayerListVC()
            VC.gameDataDelegate = self
            VC.game = self?.games[0]
            self?.navigationController?.pushViewController(VC, animated: true)
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    func errorNotEnoughPlayers() {
        let ac = UIAlertController(title: "Error: Not Enough Players", message: "You need a player", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default){[weak self] _ in
            self?.addPlayer()
        })
        present(ac, animated: true)
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
    }
    
}

