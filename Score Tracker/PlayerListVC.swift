//
//  PlayerListVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class PlayerListVC: UIViewController {
        
    var game: Game!
    
    let tableView = UITableView()
    var gameDataDelegate: GameDataDelegate?
    
    var highestScores = [0,0,0]
    var rankIndex = [0,0,0]
    
    let helpVC = HelpVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        title = game?.title
        view.subviews {
            tableView
        }
        setNotification()
        configureTableView()
        configureNavController()
        setHelpVC()
    }
    
    func configureNavController() {
        let chartButton = UIBarButtonItem(title: "Chart", style: .plain, target: self, action: #selector(chartTapped))
        let helpButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(displayHelp))
        self.navigationItem.rightBarButtonItems = [chartButton,helpButton]
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
        game.updateLastEditted()
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
        tableView.rowHeight = 120
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
        if game.players[0].pastRanks.isEmpty {
            let ac = UIAlertController(title: "No Score Recorded", message: "You need at least have one round of scores to view the chart", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        let chartVC = ChartVC()
        chartVC.players = game.players
        navigationController?.pushViewController(chartVC, animated: true)
    }
    
    func setHelpVC() {
        helpVC.modalPresentationStyle = .fullScreen
        helpVC.closeButton.addTarget(self, action: #selector(closeHelp), for: .touchUpInside)
        helpVC.helpView.image = UIImage(named: "PlayerListVC_HelpImage")
    }
    
    @objc func displayHelp() {
        helpVC.helpView.alpha = 0.0
        helpVC.closeButton.alpha = 0.0
        present(helpVC, animated: true) {
            UIView.animate(withDuration: 1, animations: {
                self.helpVC.helpView.alpha = 1.0
                self.helpVC.closeButton.alpha = 1.0
            })
        }
    }
    
    @objc func closeHelp() {
        helpVC.dismiss(animated: true)
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
            totalPointsLabel.height(80%).centerVertically().width(15%).left(44%)
            addingPointLabel.height(80%).centerVertically().width(20%).left(72%)
            
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
                cell.updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
                cell.historyButton.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
                
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell{
            cell.selectionStyle = .none
            cell.playerNameLabel.text = game.players[indexPath.row].name
            cell.totalPointsLabel.text = "\(game.players[indexPath.row].pastPoints.last ?? 0)"
            if game.players[indexPath.row].currPoint == 0 {
                cell.pointField.text = ""
            }
            else {
                cell.pointField.text = "\(game.players[indexPath.row].currPoint)"
            }

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
            
            cell.plusButton.tag = indexPath.row
            cell.minusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            cell.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
            
            cell.pointField.tag = indexPath.row
            cell.pointField.addTarget(self , action: #selector(pointFieldDidChange), for: .editingDidEnd)

            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func plusButtonTapped(_ sender: UIButton){
        game.players[sender.tag].currPoint += 1
        tableView.reloadData()
    }
    
    @objc func minusButtonTapped(_ sender: UIButton){
        game.players[sender.tag].currPoint -= 1
        tableView.reloadData()
    }
    
    @objc func pointFieldDidChange(_ textField: UITextField) {
        game.players[textField.tag].currPoint = Int(textField.text ?? "0") ?? 0
        tableView.reloadData()
    }
    
    @objc func updateTapped() {
        var allZero = true
        for i in 0..<game.players.count {
            if game.players[i].currPoint != 0 {
                allZero = false
                break
            }

        }
        
        if allZero {
            let ac = UIAlertController(title: "Update?", message: "All players have 0 points.\nDo you still want to update?", preferredStyle: .alert)
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
        VC.gameDataDelegate = self.gameDataDelegate
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func update() {
        var playersArray = [Player]()
        for i in 0..<game.players.count {
            let player = game.players[i]
            player.pastPoints.append((player.pastPoints.last ?? 0) + player.currPoint)
            player.currPoint = 0
            playersArray.append(player)
        }
        
        let sortedPlayers = playersArray.sorted(by: {$0.pastPoints.last ?? 0 > $1.pastPoints.last ?? 0})
        
        for (i, player) in sortedPlayers.enumerated() {
            player.pastRanks.append(i+1)
        }
        game.updateLastEditted()
        tableView.reloadData()
        
        gameDataDelegate?.saveGame()
    }
}
