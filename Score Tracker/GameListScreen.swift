//
//  GameListScreen.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class GameListScreen: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Game")
        setNavController()
    }
    
    func setNavController() {
        self.title = "List of Games"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game", for: indexPath)
        return cell
    }

}
