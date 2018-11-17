//
//  colorCell.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/13.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class colorCell: UICollectionViewCell{
    let cellColor = color()
    var myColor:String = "Black"
    
    lazy var colorLabel:UILabel = {
        let colorlabel = UILabel()
            colorlabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            colorlabel.backgroundColor = .clear
        return colorlabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(colorLabel)
    }
    
    func setColor(){
        colorLabel.backgroundColor = cellColor.colorArray[myColor]
    }
}
