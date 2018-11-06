//
//  ViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/01.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    let dateManager = DateManager()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width/7 - 2, height: self.view.frame.width/7 - 2)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 4
        let cview = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: (self.view.frame.width/7 + 4) * 6), collectionViewLayout: layout)
            cview.backgroundColor = UIColor(red: 255/255, green: 117/255, blue: 195/255, alpha: 1.0)
            cview.register(calendarCell.self, forCellWithReuseIdentifier: "calendarCell")
            cview.delegate = self
            cview.dataSource = self
        return cview
    }()
    let prevBtn:UIButton = {
        let prevMonthBtn = UIButton()
            prevMonthBtn.frame = CGRect(x: UIScreen.main.bounds.width/15, y: 35, width: UIScreen.main.bounds.width/6, height: 40)
            prevMonthBtn.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            prevMonthBtn.setTitle("＜", for: UIControl.State())
            prevMonthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            prevMonthBtn.setTitleColor(.darkGray, for: UIControl.State())
            prevMonthBtn.addTarget(self, action: #selector(goprevMonth), for: .touchUpInside)
        return prevMonthBtn
    }()
    let nextBtn:UIButton = {
        let nextMonthBtn = UIButton()
            nextMonthBtn.frame = CGRect(x: UIScreen.main.bounds.maxX - (UIScreen.main.bounds.width/6 + UIScreen.main.bounds.width/15), y: 35, width:UIScreen.main.bounds.width/6, height: 40)
            nextMonthBtn.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            nextMonthBtn.setTitle("＞", for: UIControl.State())
            nextMonthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            nextMonthBtn.setTitleColor(.darkGray, for: UIControl.State())
            nextMonthBtn.addTarget(self, action: #selector(gonextMonth), for: .touchUpInside)
        return nextMonthBtn
    }()
    lazy var monthLabel:UILabel = {
        let thisMonthLabel = UILabel()
            thisMonthLabel.frame = CGRect(x:UIScreen.main.bounds.width/4 + UIScreen.main.bounds.width/8, y:35, width:UIScreen.main.bounds.width/4, height:40)
            thisMonthLabel.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            thisMonthLabel.text = ""
            thisMonthLabel.textColor = .darkGray
            thisMonthLabel.text = dateManager.conversionDateFormat(indexPath: dateManager.indexOfselectedDate(), format: "yyyy/MM")
            thisMonthLabel.textAlignment = NSTextAlignment.center
        return thisMonthLabel
    }()
    
    lazy var dateLabel:UILabel = {
        let selectedDateLabel = UILabel()
            selectedDateLabel.frame = CGRect(x: self.view.frame.width/4, y: collectionView.frame.maxY, width: self.view.frame.width/2, height: 50)
            selectedDateLabel.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            selectedDateLabel.text = "nil"
            selectedDateLabel.textColor = .darkGray
            selectedDateLabel.text = dateManager.conversionDateFormat(indexPath: dateManager.indexOfselectedDate(), format: "yyyy/MM/dd")
            selectedDateLabel.textAlignment = NSTextAlignment.center
        return selectedDateLabel

    }()
    lazy var eventLabel:UILabel = {
        let eventTextLabel = UILabel()
            eventTextLabel.frame = CGRect(x: self.view.frame.width/10, y: dateLabel.frame.maxY + dateLabel.frame.height/4, width: self.view.frame.width - self.view.frame.width/5, height: (self.view.frame.maxY - dateLabel.frame.maxY)/5 * 3)
            eventTextLabel.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            eventTextLabel.text = "nil"
            eventTextLabel.textAlignment = NSTextAlignment.center
            eventTextLabel.textColor = .darkGray
        return eventTextLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRealm()
        self.loadEvent(date: dateManager.conversionDateFormat(indexPath: dateManager.indexOfselectedDate(), format: "yyyy/MM/dd"))
        self.view.backgroundColor = UIColor(red: 255/255, green: 117/255, blue: 195/255, alpha: 1.0)
        self.view.addSubview(collectionView)
        self.view.addSubview(prevBtn)
        self.view.addSubview(nextBtn)
        self.view.addSubview(dateLabel)
        self.view.addSubview(eventLabel)
        self.view.addSubview(monthLabel)
    }
    
    @objc func goprevMonth(sender: UIButton){
        monthLabel.text = dateManager.dateToString(date: dateManager.prevMonth(dateManager.selectedDate), format: "yyyy/MM")
        dateManager.dateForCellAtIndexPath(numberOfItem: dateManager.daysAcquisition())
        let date: String = dateManager.conversionDateFormat(indexPath: dateManager.indexOfselectedDate(), format: "yyyy/MM/dd")
        dateLabel.text = date
        loadEvent(date: date)
        collectionView.reloadData()
    }
    
    @objc func gonextMonth(sender: UIButton){
        monthLabel.text = dateManager.dateToString(date: dateManager.nextMonth(dateManager.selectedDate), format: "yyyy/MM")
        dateManager.dateForCellAtIndexPath(numberOfItem: dateManager.daysAcquisition())
        let date: String = dateManager.conversionDateFormat(indexPath: dateManager.indexOfselectedDate(), format: "yyyy/MM/dd")
        dateLabel.text = date
        loadEvent(date: date)
        collectionView.reloadData()
    }
    
    func setupRealm(){
        do {
            let realm = try Realm()
            let event = [Event(value:["date":"2018/11/07", "text":"散髪に行くよ"]),Event(value: ["date": "2018/12/24"])]
            print("Saving")
            try realm.write {
                realm.deleteAll()
                realm.add(event)
                print("Saved")
            }
        } catch  {
            print("Error")
        }
    }
    
    func loadEvent(date: String){
        do {
            let realm = try Realm()
            if let result = realm.objects(Event.self).filter("date = '\(date)'").last{
                eventLabel.text = result.text
            } else {
                eventLabel.text = "Nothing"
            }
            
        } catch {
            print("Error")
        }
    }
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.daysAcquisition()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath as IndexPath) as! calendarCell
        
        cell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath.row, format: "d")
        cell.textLabel.textColor = cell.setTextColor(date: dateManager.conversionDateFormat(indexPath: indexPath.row, format: "yyyy/MM/dd"))
        
        return cell
    }
}

extension ViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateManager.selectedDate = dateManager.currentMonthOfDates[indexPath.row]
        let today: String = dateManager.dateToString(date: dateManager.selectedDate, format: "yyyy/MM/dd")
        dateLabel.text = today
        loadEvent(date: today)
    }
}
