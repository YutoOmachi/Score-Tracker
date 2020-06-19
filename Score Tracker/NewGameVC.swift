//
//  NewGameVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 13/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia
import FlexColorPicker


class NewGameVC: UIViewController {
    
    var gameDataDelegate: GameDataDelegate?
    
    var tableView = UITableView()
    var selectedButton: UIButton?
    var colorPickerController: DefaultColorPickerViewController!
    var colorNavController: UINavigationController!
    
    var numPlayers = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavController()
        
        view.subviews {
            tableView
        }
        tableView.height(100%).width(100%).top(0).left(0)

        configureTableView()
        setNotification()
    }
    
    func setNavController() {
        self.title = "New Game"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Top", style: .plain, target: self, action: #selector(backToTop))
    }
        
    @objc func backToTop() {
        self.navigationController?.popToRootViewController(animated: true)
    }
        
    func setNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.register(NewGameTitleCell.self, forCellReuseIdentifier: "title")
        tableView.register(NewPlayerCell.self, forCellReuseIdentifier: "player")
        tableView.register(CreateNewGameCell.self, forCellReuseIdentifier: "newGame")
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
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
}

extension NewGameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return numPlayers
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight*0.7))
            footerView.backgroundColor = UIColor.cellColor
            
            let label = UILabel()
            let addPlayerButton = UIButton()
            footerView.subviews{
                label
                addPlayerButton
            }
            label.height(60%).width(20%).left(5%).centerVertically()
            label.text = "Players"
            label.textColor = .white
            addPlayerButton.height(60%).width(10%).right(0).centerVertically()
            addPlayerButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            addPlayerButton.tintColor = .black
            addPlayerButton.addTarget(self, action: #selector(addPlayerTapped), for: .touchUpInside)
            
            return footerView
        }
        else if section == 1 {
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
                cell.nameField.placeholder = "Player\(indexPath.row+1)"
                var color: UIColor
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
                cell.colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "newGame", for: indexPath) as? CreateNewGameCell {
                cell.createNewGameButton.layer.cornerRadius = tableView.rowHeight*0.4
                cell.createNewGameButton.addTarget(self, action: #selector(createNewGameTapped), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func createNewGameTapped() {
        let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewGameTitleCell
        var game: Game
        if let title = titleCell?.titleField.text {
            if title == "" {
                game = Game(title: "New Game")
            }
            else {
                game = Game(title: title)
            }
        }
        else {
            game = Game(title: "Game")
        }
        
        for i in 0..<numPlayers {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1)) as? NewPlayerCell
            if let name = cell?.nameField.text, let color = cell?.colorButton.backgroundColor?.rgba {
                if name == "" {
                    game.players.append(Player(name: "Player\(i+1)", color: color))
                }
                else {
                    game.players.append(Player(name: name, color: color))
                }
            }
        }
        
        gameDataDelegate?.addNewGame(game: game)
        
        let VC = PlayerListVC()
        VC.game = game
        VC.gameDataDelegate = self.gameDataDelegate
        navigationController?.pushViewController(VC, animated: true)
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.remove(at: navigationArray.count - 2)
        self.navigationController?.viewControllers = navigationArray
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        selectedButton = sender
        colorPickerController = DefaultColorPickerViewController()
        colorPickerController.delegate = self
        colorNavController = UINavigationController(rootViewController: colorPickerController)
        
        let selectButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(selectTapped(sender:)))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped(sender:)))
        colorPickerController.navigationItem.rightBarButtonItem = selectButton
        colorPickerController.navigationItem.leftBarButtonItem = cancelButton
        colorPickerController.navigationItem.leftBarButtonItem?.tintColor = .red

        present(colorNavController, animated: true, completion: nil)
    }

    @objc func selectTapped(sender: UIBarButtonItem) {
        colorNavController.dismiss(animated: true, completion: nil)
        selectedButton?.backgroundColor = colorPickerController.selectedColor
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        colorNavController.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPlayerTapped() {
        numPlayers+=1
        tableView.reloadData()
    }

}

extension NewGameVC: ColorPickerDelegate {
}
