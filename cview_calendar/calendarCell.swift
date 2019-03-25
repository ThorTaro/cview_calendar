//
//  calendarCell.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/01.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit
import RealmSwift

class calendarCell: UICollectionViewCell {
    lazy var textLabel:UILabel = {
        let label = UILabel()
            label.frame = CGRect(x: self.frame.width/6, y: self.frame.height/6, width: self.frame.width/6 * 4, height: self.frame.height/6 * 4)
            label.backgroundColor = UIColor(red: 255/255, green: 200/255, blue: 150/255, alpha: 1.0)
            label.textAlignment = NSTextAlignment.center
            label.layer.masksToBounds = true
            label.layer.cornerRadius = label.frame.width/2
        return label
    }()
    
    lazy var morningArc:CAShapeLayer = {
        let arcLayer = makeArc(time: "Morning")
            arcLayer.fillColor = UIColor.red.cgColor
        return arcLayer
    }()
    
    lazy var afternoonArc:CAShapeLayer = {
        let arcLayer = makeArc(time: "Afternoon")
            arcLayer.fillColor = UIColor.yellow.cgColor
        return arcLayer
    }()
    
    lazy var nightArc:CAShapeLayer = {
        let arcLayer = makeArc(time: "Night")
            arcLayer.fillColor = UIColor.orange.cgColor
        return arcLayer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.insertSublayer(morningArc, at: 0)
        self.layer.insertSublayer(afternoonArc, at: 1)
        self.layer.insertSublayer(nightArc, at: 2)
        self.contentView.addSubview(textLabel)
    }
    
    func makeArc(time:String) -> CAShapeLayer{
        var startAngle:CGFloat = 0.0
        var endAngle:CGFloat = 0.0
        if time == "Morning"{
            startAngle = CGFloat(Double.pi)/2 * 3
            endAngle = CGFloat(Double.pi)/6
        }else if time == "Afternoon"{
            startAngle = CGFloat(Double.pi)/6
            endAngle = CGFloat(Double.pi) - CGFloat(Double.pi)/6
        }else if time == "Night"{
            startAngle = CGFloat(Double.pi) - CGFloat(Double.pi)/6
            endAngle = CGFloat(Double.pi)/2 * 3
        }
        let circle = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: self.frame.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            circle.addLine(to: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        let layer = CAShapeLayer()
            //layer.fillColor = UIColor.yellow.cgColor
            layer.path = circle.cgPath
        return layer
    }
    
    
    func setTextColor(date: String) -> UIColor{
        do {
            let realm = try Realm()
            if realm.objects(Event.self).filter("date = '\(date)'").last != nil{
                return UIColor.red
            } else {
                return UIColor.darkGray
            }
            
        } catch {
            print("Error")
            return UIColor.darkGray
        }
    }
}
