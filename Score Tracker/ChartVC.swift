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

enum DataType {
    case Point
    case Rank
}
enum NumGame {
    case all
    case past10
}

class ChartVC: UIViewController{
    
    var players = [Player]()
    
    var pointData = [[ChartDataEntry]]()
    var recentPointData = [[ChartDataEntry]]()
    
    var rankData = [[ChartDataEntry]]()
    var recentRankData = [[ChartDataEntry]]()
    
    var dataType = DataType.Point
    var numGame = NumGame.all
    
    let numGameControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["ALL", "Past 10"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0

        sc.addTarget(self, action: #selector(handleNumGameControlChange), for: .valueChanged)
        return sc
    }()
    
    let dataTypeControl: UISegmentedControl = {
         let sc = UISegmentedControl(items: ["Points", "Rank"])
         sc.translatesAutoresizingMaskIntoConstraints = false
         sc.tintColor = UIColor.white
         sc.selectedSegmentIndex = 0

         sc.addTarget(self, action: #selector(handleDataTypeControlChange), for: .valueChanged)
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
        xAxis.labelPosition = .bottom
        xAxis.granularityEnabled = true
        xAxis.granularity = 2
        
        return chartView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.subviews{
            lineChartView
            dataTypeControl
        }
        lineChartView.height(80%).bottom(0).width(100%).left(0)
        dataTypeControl.height(5%).top(5%).width(60%).left(20%)
        setCharData()
        setData()
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleNumGameControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            numGame = .past10
        default:
            numGame = .all
        }
        
        setData()
    }
    
    @objc func handleDataTypeControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            dataType = .Rank
        default:
            dataType = .Point
        }
        setData()
    }
    
    func setCharData() {
        for player in players {
            var pData = [ChartDataEntry]()
            var rData = [ChartDataEntry]()
            for i in 0..<player.pastPoints.count {
                pData.append(ChartDataEntry(x: Double(i), y: Double(player.pastPoints[i])))
                rData.append(ChartDataEntry(x: Double(i), y: Double(player.pastRanks[i])))
            }
            pointData.append(pData)
            rankData.append(rData)
            recentPointData.append(pData.suffix(10))
            recentRankData.append(rData.suffix(10))
        }
    }
    

    func setData() {
        var dataSets = [LineChartDataSet]()
        var selectedData = [[ChartDataEntry]]()
        if dataType == .Point {
            if numGame == .all {
                selectedData = pointData
            }
            else {
                selectedData = recentPointData
            }
        }
        else {
            if numGame == .all {
                selectedData = rankData
            }
            else {
                selectedData = recentRankData
            }
        }
        
        for (i, data) in selectedData.enumerated() {
            let set = LineChartDataSet(entries: data, label: "\(players[i].name)")
            
            var color = UIColor.white
            
            switch i%6 {
            case 0:
                color = .cellColor
            case 1:
                color = .navigationColor
            case 2:
                color = .magenta
            case 3:
                color = .cyan
            case 4:
                color = .lightGray
            case 5:
                color = .brown
            default:
                color = .red
            }
            set.setColor(color)
            set.setCircleColor(color)
            
            set.drawCirclesEnabled = false
            if dataType == .Point {
                set.mode = .linear
                lineChartView.leftAxis.inverted = false
                set.drawCirclesEnabled = false
            }
            else {
                set.mode = .linear
                lineChartView.leftAxis.granularityEnabled = true
                lineChartView.leftAxis.granularity = 1.0
                lineChartView.leftAxis.inverted = true
                set.drawCirclesEnabled = true
            }
            set.lineWidth = 3
            set.drawHorizontalHighlightIndicatorEnabled = false
            dataSets.append(set)
        }

        
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        lineChartView.data = data
        lineChartView.setVisibleXRangeMaximum(10.0)
        lineChartView.moveViewToX(Double(players[0].pastPoints.count))
    }

}




extension ChartVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    


}
