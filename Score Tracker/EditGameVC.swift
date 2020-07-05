//
//  EditGameVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 3/7/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia
import FlexColorPicker  

class EditGameVC: UIViewController {

    var gameDataDelegate: GameDataDelegate?
    
    var tableView = UITableView()
    var selectedCell: NewPlayerCell?
    var colorPickerController: DefaultColorPickerViewController!
    var colorNavController: UINavigationController!
    
    var selectedGame: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.subviews {
            tableView
        }
        tableView.size(100%)
        
        configureTableView()
        setTableViewDelegates()
        
        setNavController()
        setNotification()
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
    
    func setNavController() {
        self.title = "(Editting Mode)"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white, .font: UIFont.myBoldSystemFont(ofSize: 22)]
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
        
    func setNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
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

extension EditGameVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return selectedGame?.players.count ?? 0
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight/2))
            footerView.backgroundColor = UIColor.cellColor
            
            let label = UILabel()
            footerView.subviews{
                label
            }
            label.height(60%).width(20%).left(5%).centerVertically()
            let text = "Players"
            let attr: [NSAttributedString.Key:Any] = [
                .font: UIFont.mySystemFont(ofSize: 22),
                .foregroundColor: UIColor.white
            ]
            label.attributedText = NSAttributedString(string: text, attributes: attr)
            return footerView
        }
        else if section == 1 {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.rowHeight/2))
        }
        
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.rowHeight/2
        }
        return tableView.rowHeight/3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as? NewGameTitleCell {
                cell.titleField.text = selectedGame?.title
                return cell
            }
        case 1:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath) as? NewPlayerCell {
                cell.nameField.text = selectedGame?.players[indexPath.row].name
                let playerColor = selectedGame?.players[indexPath.row].color ?? [0,0,0,0]
                let color  = UIColor(red: (playerColor[0]), green: (playerColor[1]), blue: playerColor[2], alpha: playerColor[3])
                cell.colorButton.backgroundColor = color
                cell.colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
                return cell
            }
            
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "newGame", for: indexPath) as? CreateNewGameCell {
                cell.createNewGameButton.layer.cornerRadius = tableView.rowHeight*0.4
                let text = "Save Changes"
                let attr: [NSAttributedString.Key : Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.myBoldSystemFont(ofSize: 22)
                ]
                let attrString = NSAttributedString(string: text, attributes: attr)
                cell.createNewGameButton.setAttributedTitle(attrString, for: .normal)
                cell.createNewGameButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func editTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {

        
        
        selectedCell = sender.superview?.superview as? NewPlayerCell
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
        selectedCell?.color = colorPickerController.selectedColor
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        colorNavController.dismiss(animated: true, completion: nil)
    }
}

extension EditGameVC: ColorPickerDelegate {
    
}
