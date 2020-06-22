//
//  HistoryVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 22/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Stevia

class HistoryVC: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.subviews {
            tableView
        }
        
        tableView.height(100%).width(100%).left(0).top(0)
        tableView.backgroundColor = .backgroundColor
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "history")
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as? HistoryCell{
            cell.numCol = 5
            cell.
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return { let view = UIView()
            view.height(30%).width(100%).centerVertically().centerHorizontally()
            view.backgroundColor = .cyan
            return view
        }()
    }
}
