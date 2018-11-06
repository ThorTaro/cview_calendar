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
            label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            label.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(textLabel)
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
