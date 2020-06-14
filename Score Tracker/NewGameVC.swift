//
//  NewGameVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 13/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class NewGameVC: UIViewController {
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavController()
        
        view.subviews {
            tableView
        }
        
        tableView.pin(to: view)
        
        configureTableView()
    }
    
    func setNavController() {
        self.title = "List of Games"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(NewGameTitleCell.self, forCellReuseIdentifier: "title")
        tableView.register(NewPlayerCell.self, forCellReuseIdentifier: "player")
        tableView.register(CreateNewGameCell.self, forCellReuseIdentifier: "newGame")
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension NewGameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight*0.7))
            headerView.backgroundColor = UIColor.cellColor
            
            let label = UILabel()
            let addPlayerButton = UIButton()
            headerView.subviews{
                label
                addPlayerButton
            }
            label.height(60%).width(20%).left(10%).centerVertically()
            label.text = "Players"
            label.textColor = .white
            addPlayerButton.height(60%).width(10%).right(0).centerVertically()
            addPlayerButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            
            return headerView
        }
        else if section == 2 {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight/2))
        }
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as? NewGameTitleCell {
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as? NewPlayerCell {
                cell.nameField.placeholder = "Player\(indexPath.row)"
                cell.handicapField.placeholder = "0"
                
                let color: UIColor!
                switch indexPath.row%6 {
                case 0:
                    color = .cyan
                case 1:
                    color = .navigationColor
                case 2:
                    color = .magenta
                case 3:
                    color = .cellColor
                case 4:
                    color = .lightGray
                case 5:
                    color = .brown
                default:
                    color = .red
                }
                cell.colorButton.backgroundColor = color
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "newGame", for: indexPath) as? CreateNewGameCell {
                cell.createNewGameButton.layer.cornerRadius = tableView.rowHeight*0.4
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}
