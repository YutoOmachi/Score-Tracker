//
//  colorExtension.swift
//  Score Tracker
//
//  Created by 小町悠登 on 5/6/20.
//  Copyright © 2020 Yuto Omachi. All rights reserved.
//
import UIKit

extension UIColor 
{
    static let navigationColor = UIColor(red: 81.0/255.0, green: 132.0/255.0, blue: 148.0/255.0, alpha: 1.0)
    static let cellColor = UIColor(red: 255.0/255.0, green: 177.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    static let backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    static let updateColor = UIColor(red: 192.0/255.0, green: 53.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    static let gold = UIColor(red: 255.0/255.0, green: 215.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let silver = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    static let bronze = UIColor(red: 205.0/255.0, green: 127.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let whiteGray = UIColor(red: 190.0/255.0, green: 190.0/255.0, blue: 190.0/255.0, alpha: 1.0)
    static let darkGray = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 0.8)
    
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return [red, green, blue, alpha]
    }
}

//extension UIImage {
//    
//    convenience init?(contentsOfFile name: String) {
//        print("\(name)\(RESOLUTION)")
//        let imgName = "\(name)\(RESOLUTION)"
//        guard let imagePath = Bundle.main.path(forResource: imgName, ofType: "png") else {
//            print("returning nil")
//            return nil
//        }
//        self.init(contentsOfFile: imagePath)
//    }
//    
//}
