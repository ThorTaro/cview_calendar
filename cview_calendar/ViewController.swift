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
    let dateManager = DateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionViewの設定
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 100), collectionViewLayout: layout)
        collectionView.backgroundColor = .orange
        collectionView.register(calendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        
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
