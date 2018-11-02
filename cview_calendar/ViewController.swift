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
    let dateManager = DateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionViewの設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/7 - 2, height: self.view.frame.width/7 - 2)
        layout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height/2), collectionViewLayout: layout)
        collectionView.backgroundColor = .orange
        collectionView.register(calendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        prevBtn.frame = CGRect(x: self.view.frame.width/4, y: 0, width: self.view.frame.width/2, height: 80)
        prevBtn.backgroundColor = .lightGray
        prevBtn.addTarget(self, action: #selector(goprevMonth), for: .touchUpInside)
        self.view.addSubview(prevBtn)
        
    }
    
    @objc func goprevMonth(sender: UIButton){
        dateManager.prevMonth(dateManager.selectedDate)
        collectionView.reloadData()
    }
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.daysAcquisition()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath as IndexPath) as! calendarCell
        
        cell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath)
        
        return cell
    }
    
    
}

extension ViewController:UICollectionViewDelegate{
    
}
