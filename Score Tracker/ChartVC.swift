//
//  ChartVC.swift
//  Score Tracker
//
//  Created by 小町悠登 on 10/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit
import Charts
import Stevia

class ChartVC: UIViewController{
    
    var players = [Player]()
    var charData = [[ChartDataEntry]]()
    var selectedCharData = [[ChartDataEntry]]()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ALL", "Past 10"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0

        sc.addTarget(self, action: #selector(handleSegmentedControlChange), for: .valueChanged)
        return sc
    }()
    
    lazy var lineChartView: LineChartView = {
        
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor.white
        
        chartView.rightAxis.enabled = false
        
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .lightGray
        yAxis.axisLineColor = .lightGray
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = .lightGray
        xAxis.axisLineColor = .lightGray
        xAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(6, force: false)
                
        return chartView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        players = samplePlayers
        setSamplePoints()
        
        view.subviews{
            lineChartView
            segmentedControl
        }
        lineChartView.height(80%).bottom(0).width(100%).left(0)
        segmentedControl.height(10%).top(5%).width(60%).left(20%)
        setCharData()
        selectedCharData = charData
        setData()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            for (i,data) in charData.enumerated() {
                selectedCharData[i] = data.suffix(10)
            }
        default:
            selectedCharData = charData
        }
        
        setData()
    }
    
    func setCharData() {
        for player in players {
            var data = [ChartDataEntry]()
            for (i, point) in player.pastPoints.enumerated() {
                data.append(ChartDataEntry(x: Double(i), y: Double(point)))
            }
            charData.append(data)
        }
    }

    func setData() {
        var dataSets = [LineChartDataSet]()
        
        for (i, data) in selectedCharData.enumerated() {
            let set = LineChartDataSet(entries: data, label: "\(players[i].name)")
            set.drawCirclesEnabled = false
        
            set.mode = .linear
            set.lineWidth = 3
            set.drawHorizontalHighlightIndicatorEnabled = false
            dataSets.append(set)
            
            switch i%6 {
            case 0:
                set.setColor(UIColor.cellColor)
            case 1:
                set.setColor(UIColor.black)
            case 2:
                set.setColor(UIColor.cyan)
            case 3:
                set.setColor(UIColor.green)
            case 4:
                set.setColor(UIColor.lightGray)
            case 5:
                set.setColor(UIColor.brown)
            default:
                set.setColor(UIColor.red)
            }
        }
        
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    let samplePlayers:[Player] = [
    Player(name: "Ayari"),
    Player(name: "Sara"),
    Player(name: "Tomoko"),
    Player(name: "Tetsuo")]
    
    func setSamplePoints() {
        for player in samplePlayers {
            for i in 1...20 {
                player.pastPoints.append(Int.random(in: 1+i...10+i))
            }
        }
    }

}




extension ChartVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    


}
