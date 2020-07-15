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


protocol GameDataDelegate {
    func didGameUpdated(game: Game)
    func addNewGame(game: Game)
    func saveGame()
}

class NewGameVC: UIViewController {
    
    var gameDataDelegate: GameDataDelegate?
    
    var tableView = UITableView()
    var selectedRow: Int?
    var colorPickerController: DefaultColorPickerViewController!
    var colorNavController: UINavigationController!

    let helpVC = HelpVC()
    
    var newGame = Game(title: "", firstCreated: Date())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        setNavController()
        
        view.subviews {
            tableView
        }
        tableView.height(100%).width(100%).top(0).left(0)

        configureTableView()
        initNewGame()
        setNotification()
        setHelpVC()
    }
    
    func setNavController() {
        self.title = "New Game"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.myBoldSystemFont(ofSize: 22)]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToTop))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(displayHelp))
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
        tableView.rowHeight = 120
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.register(NewGameTitleCell.self, forCellReuseIdentifier: "title")
        tableView.register(NewPlayerCell.self, forCellReuseIdentifier: "player")
        tableView.register(CreateNewGameCell.self, forCellReuseIdentifier: "newGame")
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func initNewGame() {
        newGame.players.append(Player(name: "", color: UIColor.cyan.rgba))
        newGame.players.append(Player(name: "", color: UIColor.navigationColor.rgba))
    }
    
    func setHelpVC() {
        helpVC.closeButton.addTarget(self, action: #selector(closeHelp), for: .touchUpInside)
        helpVC.modalPresentationStyle = .fullScreen
        helpVC.helpView.image = UIImage(named: "NewGameVC_HelpImage")
    }
    
    @objc func displayHelp() {
        helpVC.helpView.alpha = 0.0
        present(helpVC, animated: true) {
            UIView.animate(withDuration: 1, animations: {
                self.helpVC.helpView.alpha = 1.0
            })
        }
    }
    
    @objc func closeHelp() {
        helpVC.dismiss(animated: true) 
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {

        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 10, right: 0)
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
            return newGame.players.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as? NewGameTitleCell {
                cell.titleField.addTarget(self, action: #selector(self.titleFieldDidChange(_:)), for: .editingDidEnd)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as? NewPlayerCell {
                if newGame.players[indexPath.row].name == "" {
                    cell.nameField.placeholder = "Player\(indexPath.row+1)"
                }
                cell.nameField.text = newGame.players[indexPath.row].name
                
                cell.tag = indexPath.row
                let player = newGame.players[indexPath.row]
                let playerColor = UIColor(red: player.color[0], green: player.color[1], blue: player.color[2], alpha: player.color[3])
                cell.colorButton.backgroundColor = playerColor
                cell.colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
                cell.nameField.addTarget(self, action: #selector(nameFieldDidChange(_:)), for: .editingDidEnd)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "newGame", for: indexPath) as? CreateNewGameCell {
                cell.createNewGameButton.layer.cornerRadius = tableView.rowHeight*0.4
                let text = "Start Game"
                let attr: [NSAttributedString.Key : Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.myBoldSystemFont(ofSize: 22)
                ]
                let attrString = NSAttributedString(string: text, attributes: attr)
                cell.createNewGameButton.setAttributedTitle(attrString, for: .normal)
                cell.createNewGameButton.addTarget(self, action: #selector(createNewGameTapped), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func titleFieldDidChange(_ textField: UITextField) {
        newGame.title = textField.text ?? ""
    }
    
    @objc func createNewGameTapped() {
        if newGame.title == "" {
            newGame.title = "New Game"
        }
        for (i, player) in newGame.players.enumerated() {
            if player.name == "" {
                player.name = "Player\(i+1)"
            }
        }
        
        gameDataDelegate?.addNewGame(game: newGame)
        
        let VC = PlayerListVC()
        VC.game = newGame
        VC.gameDataDelegate = self.gameDataDelegate
        navigationController?.pushViewController(VC, animated: true)
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.remove(at: navigationArray.count - 2)
        self.navigationController?.viewControllers = navigationArray
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        selectedRow = sender.superview?.superview?.tag
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
        newGame.players[selectedRow ?? -1].color = colorPickerController.selectedColor.rgba
        tableView.reloadData()
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        colorNavController.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPlayerTapped() {
        var color: UIColor
        switch newGame.players.count {
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
        newGame.players.append(Player(name: "", color: color.rgba))
        tableView.reloadData()
    }
    
    @objc func nameFieldDidChange(_ nameField: UITextField) {
        guard let cell = nameField.superview?.superview as? UITableViewCell else {
            return
        }
        newGame.players[cell.tag].name = nameField.text ?? ""
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight/2))
            footerView.backgroundColor = UIColor.cellColor
            
            let label = UILabel()
            let addPlayerButton = UIButton()
            footerView.subviews{
                label
                addPlayerButton
            }
            label.height(60%).width(20%).left(5%).centerVertically()
            let text = "Players"
            let attr: [NSAttributedString.Key:Any] = [
                .font: UIFont.mySystemFont(ofSize: 22),
                .foregroundColor: UIColor.white
            ]
            label.attributedText = NSAttributedString(string: text, attributes: attr)
            addPlayerButton.height(90%).width(20%).right(0).centerVertically()
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
            addPlayerButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
            addPlayerButton.tintColor = .white
            addPlayerButton.layer.shadowColor = UIColor.black.cgColor
            addPlayerButton.layer.shadowRadius = 4
            addPlayerButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            addPlayerButton.layer.shadowOpacity = 0.5
            addPlayerButton.addTarget(self, action: #selector(addPlayerTapped), for: .touchUpInside)
            
            return footerView
        }
        else if section == 2 {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight/2))
        }
        
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        if section == 1 {
            return tableView.rowHeight/2
        }
        return tableView.rowHeight/3
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let delete = UIContextualAction(style: .destructive, title: "Delete"){
                [weak self] (action, view, nil) in
                self?.deleteTapped(indexPath: indexPath)
            }
            delete.image = UIImage(systemName: "trash")
            let config = UISwipeActionsConfiguration(actions: [delete])
            config.performsFirstActionWithFullSwipe = true
            return config
        }
        return nil
    }

    func deleteTapped(indexPath: IndexPath) {
        newGame.players.remove(at: indexPath.row)
        print(newGame.players.count)
        for i in 0..<newGame.players.count {
            print("\(i): \(newGame.players[i].name)")
        }

        tableView.reloadData()
    }
}

extension NewGameVC: ColorPickerDelegate {
}

