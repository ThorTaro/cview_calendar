//
//  calendarCell.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/01.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class calendarCell: UICollectionViewCell {
    var textLabel:UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        //textLabel.backgroundColor = .yellow
        textLabel.textAlignment = NSTextAlignment.center
        
        self.contentView.addSubview(textLabel)
    }
}
