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
enum Visible {
    case all
    case ten
}

class ChartVC: UIViewController{
    
    var players = [Player]()
    
    var pointData = [[ChartDataEntry]]()
    var rankData = [[ChartDataEntry]]()
    
    var dataType = DataType.Point
    var visibleGame = Visible.all
    
    let visibleGameControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Overview", "Zoom to 10"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0

        sc.addTarget(self, action: #selector(handleVisibleGameControlChange), for: .valueChanged)
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
        
        chartView.animate(xAxisDuration: 1)
        
        return chartView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavController()
        view.subviews{
            lineChartView
            dataTypeControl
            visibleGameControl
        }
        setLayouts()
        setCharData()
        setData()
    }
        
    func setLayouts() {
        lineChartView.height(80%).bottom(0).width(100%).left(0)
        dataTypeControl.height(5%).top(3%).width(60%).left(20%)
        visibleGameControl.height(5%).top(10%).width(60%).left(20%)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setNavController() {
        let saveButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareChartTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func shareChartTapped(_ sender: UIBarButtonItem) {
        guard let chartImage: UIImage = lineChartView.getChartImage(transparent: false) else { sharingFailed(); return }
        
        let activityViewController = UIActivityViewController(activityItems: [chartImage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true)
    }
    
    func sharingFailed() {
        let ac = UIAlertController(title: "Failed", message: "Something went wrong! Unable to share the chart", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func handleVisibleGameControlChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            visibleGame = .ten
        default:
            visibleGame = .all
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
        }
    }
    

    func setData() {
        var dataSets = [LineChartDataSet]()
        var selectedData = [[ChartDataEntry]]()
        if dataType == .Point {
            selectedData = pointData
        }
        else {
            selectedData = rankData

        }
        
        for (i, data) in selectedData.enumerated() {
            let set = LineChartDataSet(entries: data, label: "\(players[i].name)")
            
            let colorCode = players[i].color
            let color = UIColor(red: colorCode[0], green: colorCode[1], blue: colorCode[2], alpha: colorCode[3])

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
        
        if visibleGame == .all {
            lineChartView.moveViewToX(0)
            lineChartView.setVisibleXRange(minXRange: Double(dataSets[0].count), maxXRange: Double.infinity)
        }
        else {
            lineChartView.setVisibleXRange(minXRange: 0, maxXRange: 10)
        }
        lineChartView.moveViewToX(Double(players[0].pastPoints.count))
    }
}

extension ChartVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
