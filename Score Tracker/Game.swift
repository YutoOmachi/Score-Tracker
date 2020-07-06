//
//  Game.swift
//  Score Tracker
//
//  Created by 小町悠登 on 7/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//

import UIKit

class Game: NSObject, Codable, NSCopying {
    var title: String
    var players = [Player]()
    var firstCreated: Date
    var lastEditted: Date
    
    init(title: String, firstCreated: Date) {
        self.title = title
        self.firstCreated = firstCreated
        self.lastEditted = Date()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Game(title: title, firstCreated: firstCreated)
        for i in 0..<players.count {
            copy.players.append(players[i].copy() as! Player)
        }
        copy.lastEditted = lastEditted
        return copy
    }
    
    private func formatDate(date: Date) -> String {
           let dateFormatter = DateFormatter()
           
           // date is today: return time only
           if Calendar.current.isDateInToday(date) {
               dateFormatter.dateStyle = .none
               dateFormatter.timeStyle = .short
               return dateFormatter.string(from: date)
           }
           
           // date is yesterday: return a fixed string
           if Calendar.current.isDateInYesterday(date) {
               return "Yesterday"
           }
           
           // check if it's with in a week, if so return the days of the week
           if let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: NSDate() as Date) {
               let lastWeek = DateInterval(start: lastWeekDate, end: Date())
               if lastWeek.contains(date) {
                   return dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
               }
           }

           // date not today: return date
           dateFormatter.dateStyle = .short
           dateFormatter.timeStyle = .none
           return dateFormatter.string(from: date)
       }
    
    func updateLastEditted() {
        lastEditted = Date()
    }
    
    func getFormattedLastEditted() -> String {
        return formatDate(date: lastEditted)
    }
    
    func getFormattedFirstCreated() -> String {
        return formatDate(date: firstCreated)
    }
}
