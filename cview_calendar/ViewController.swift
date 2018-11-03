//
//  ViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/01.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var collectionView:UICollectionView!
    var prevBtn:UIButton = UIButton()
    var nextBtn:UIButton = UIButton()
    let dateManager = DateManager()
    var dateLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionViewの設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/7 - 2, height: self.view.frame.width/7 - 2)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 4
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: (self.view.frame.width/7 + 4) * 6), collectionViewLayout: layout)
        collectionView.backgroundColor = .orange
        collectionView.register(calendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        // 先月のカレンダーを表示するボタン
        prevBtn.frame = CGRect(x: self.view.frame.width/4, y: 35, width: self.view.frame.width/4, height: 40)
        prevBtn.backgroundColor = .lightGray
        prevBtn.addTarget(self, action: #selector(goprevMonth), for: .touchUpInside)
        self.view.addSubview(prevBtn)
        
        // 来月のカレンダーを表示するボタン
        nextBtn.frame = CGRect(x: prevBtn.frame.maxX, y: prevBtn.frame.minY, width: prevBtn.frame.width, height: prevBtn.frame.height)
        nextBtn.backgroundColor = .darkGray
        nextBtn.addTarget(self, action: #selector(gonextMonth), for: .touchUpInside)
        self.view.addSubview(nextBtn)
        
        // タップした日付をyyyy/MM/ddで表示するラベル
        dateLabel.frame = CGRect(x: self.view.frame.width/4, y: collectionView.frame.maxY + 30, width: self.view.frame.width/2, height: 50)
        dateLabel.backgroundColor = .orange
        dateLabel.text = "nil"
        dateLabel.text = dateManager.setDateLabel(index: dateManager.indexOfselectedDate(), format: "yyyy/MM/dd")
        dateLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(dateLabel)
        
    }
    
    @objc func goprevMonth(sender: UIButton){
        dateManager.prevMonth(dateManager.selectedDate)
        collectionView.reloadData()
    }
    
    @objc func gonextMonth(sender: UIButton){
        dateManager.nextMonth(dateManager.selectedDate)
        collectionView.reloadData()
    }
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.daysAcquisition()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath as IndexPath) as! calendarCell
        
        cell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath, format: "d")
        
        if indexPath.row == dateManager.indexOfselectedDate(){
            cell.textLabel.backgroundColor = .magenta
        }else{
            cell.textLabel.backgroundColor = .yellow
        }
        
        
        return cell
    }
    
    
}

extension ViewController:UICollectionViewDelegate{
    
}
