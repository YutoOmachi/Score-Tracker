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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.myBoldSystemFont(ofSize: 22)]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewGameTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToTop))
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
            cell.playerLabel.text = "\(games[indexPath.row].players.count) players"
            cell.lastEdittedLable.text = games[indexPath.row].getFormattedLastEditted()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = PlayerListVC()
        VC.gameDataDelegate = self
        let selectedGame = games[indexPath.row]
        selectedGame.updateLastEditted()
        VC.game = selectedGame
        games.remove(at: indexPath.row)
        games.insert(selectedGame, at: 0)
        navigationController?.pushViewController(VC, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){
            [weak self] (action, view, nil) in
            self?.deleteTapped(indexPath: indexPath)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit"){
            [weak self] (action, view, nil) in
            // Edit action to be implemented
            
            
            
        }
        delete.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [edit,delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func deleteTapped(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete?", message: "Do you really want to delete? \n(deleted game can't be restored)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive){
                [weak self] _ in
                self?.games.remove(at: indexPath.row)
                self?.tableView.reloadData()
                self?.save()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
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

