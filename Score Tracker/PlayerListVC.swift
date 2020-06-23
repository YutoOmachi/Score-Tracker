//
//  PlayerListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

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
        view.subviews {
            tableView
        }
        setNotification()
        configureTableView()
        configureNavController()
    }
    
    func configureNavController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chart", style: .plain, target: self, action: #selector(chartTapped))
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.myBoldSystemFont(ofSize: 22)]
    }
    
    func setNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        game.updateLastEditted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNotification()
        tableView.reloadData()
    }

    @objc func keyboardWillChange(_ notification: Notification) {

        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 30, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func configureTableView() {
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.register(UpdateCell.self, forCellReuseIdentifier: "UpdateCell")
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.height(100%).width(100%).top(0).left(0)
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
            return 2
        }
        return game?.players.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerHeight: CGFloat = 50.0
            let headerView = UIView()
            headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
            headerView.backgroundColor = UIColor.navigationColor.withAlphaComponent(0.5)
            
            let nameLabel = UILabel()
            let rankLabel = UILabel()
            let totalPointsLabel = UILabel()
            let addingPointLabel = UILabel()
            
            headerView.subviews {
                nameLabel
                rankLabel
                totalPointsLabel
                addingPointLabel
            }
            
            nameLabel.height(80%).centerVertically().width(25%).left(20)
            rankLabel.height(80%).centerVertically().width(10%).left(27%)
            totalPointsLabel.height(80%).centerVertically().width(15%).left(47%)
            addingPointLabel.height(80%).centerVertically().width(20%).left(76%)
            
            let attr: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkGray,
                                                       .font: UIFont.mySystemFont(ofSize: 16)
            ]
            
            nameLabel.attributedText = NSAttributedString(string: "Name", attributes: attr)
            rankLabel.attributedText = NSAttributedString(string: "Rank", attributes: attr)
            totalPointsLabel.attributedText = NSAttributedString(string: "Total", attributes: attr)
            addingPointLabel.attributedText = NSAttributedString(string: "Add", attributes: attr)
            
            return headerView
        }

        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerHeight:CGFloat = 10.0
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: footerHeight).isActive = true
        return view
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCell", for: indexPath) as? UpdateCell {
                cell.selectionStyle = .none
                var text: String?
                if indexPath.row == 0 {
                    text = "Update"
                    cell.updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
                    cell.updateButton.backgroundColor = UIColor.cellColor
                }
                else if indexPath.row == 1 {
                    cell.updateButton.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
                    text = "History"
                    cell.updateButton.backgroundColor = .gray
                }
                
                let attr: [NSAttributedString.Key : Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.myBoldSystemFont(ofSize: 22)
                ]
                let attrString = NSAttributedString(string: text ?? "", attributes: attr)
                cell.updateButton.setAttributedTitle(attrString, for: .normal)
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell{
            cell.selectionStyle = .none
            cell.playerNameLabel.text = game.players[indexPath.row].name
            cell.totalPointsLabel.text = "\(game.players[indexPath.row].pastPoints.last ?? 0)"
            
            let colorCode = game.players[indexPath.row].color
            let playerColor = UIColor(red: colorCode[0], green: colorCode[1], blue: colorCode[2], alpha: colorCode[3])
            let buttonAttr: [NSAttributedString.Key : Any] = [.font: UIFont.myBoldSystemFont(ofSize: 18), .foregroundColor: playerColor, .strokeColor: UIColor.black, .strokeWidth: -3]
            cell.playerNameLabel.attributedText = NSAttributedString(string: "\(game.players[indexPath.row].name)", attributes: buttonAttr)
            
            let text = "★"
            var attr = [NSAttributedString.Key: Any]()
            
            switch game.players[indexPath.row].pastRanks.last ?? 0 {
            case 1:
                attr = [.foregroundColor: UIColor.gold,
                        .strokeColor: UIColor.black,
                        .strokeWidth: -1
                ]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            case 2:
                attr = [.foregroundColor: UIColor.silver,
                        .strokeColor: UIColor.black,
                        .strokeWidth: -1
                ]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            case 3:
                attr = [.foregroundColor: UIColor.bronze,
                        .strokeColor: UIColor.black,
                        .strokeWidth: -1
                ]
                cell.starLabel.attributedText = NSAttributedString(string: text, attributes: attr)
            default:
                cell.starLabel.attributedText = nil
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func updateTapped() {
        var allZero = true
        for i in 0..<game.players.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PlayerCell {
                if (Int(cell.pointField.text ?? "0") ?? 0) != 0 {
                    allZero = false
                    break
                }
            }
        }
        
        if allZero {
            let ac = UIAlertController(title: "Update?", message: "All players have 0 points added.\nDo you still want to update?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Update", style: .default) { [weak self] _ in
                self?.update()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        else {
            update()
        }
    }
    
    @objc func historyTapped() {
        let VC = HistoryVC()
        VC.game = game
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func update() {
        var playersArray = [Player]()
        for i in 0..<game.players.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PlayerCell, let addingPoint = cell.pointField.text{
                game.players[i].pastPoints.append((game.players[i].pastPoints.last ?? 0) + (Int(addingPoint) ?? 0))
                cell.pointField.text = ""
                playersArray.append(game.players[i])
            }
        }
        
        let sortedPlayers = playersArray.sorted(by: {$0.pastPoints.last ?? 0 > $1.pastPoints.last ?? 0})
        
        for (i, player) in sortedPlayers.enumerated() {
            player.pastRanks.append(i+1)
        }
        game.updateLastEditted()
        gameDataDelegate.didGameUpdated(game: game)
        tableView.reloadData()
    }
}
