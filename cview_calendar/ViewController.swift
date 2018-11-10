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
    lazy var morningButton:UIButton = {
        let morningEventBtn = UIButton()
            morningEventBtn.frame = CGRect(x: self.view.frame.width/10, y: dateLabel.frame.maxY + dateLabel.frame.height/4, width: self.view.frame.width - self.view.frame.width/5, height: (self.view.frame.maxY - dateLabel.frame.maxY)/5)
            morningEventBtn.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            morningEventBtn.setTitle("Morning is nil", for: UIControl.State())
            morningEventBtn.titleLabel?.textAlignment = NSTextAlignment.center
            morningEventBtn.setTitleColor(.darkGray, for: UIControl.State())
            morningEventBtn.tag = 0
            morningEventBtn.addTarget(self, action: #selector(toEditScreen), for: .touchUpInside)
        return morningEventBtn
    }()
    lazy var afternoonButton:UIButton = {
        let afternoonEventBtn = UIButton()
            afternoonEventBtn.frame = CGRect(x: self.view.frame.width/10, y: morningButton.frame.maxY + dateLabel.frame.height/4, width: self.view.frame.width - self.view.frame.width/5, height: (self.view.frame.maxY - dateLabel.frame.maxY)/5)
            afternoonEventBtn.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            afternoonEventBtn.setTitle("Afternoon is nil", for: UIControl.State())
            afternoonEventBtn.titleLabel?.textAlignment = NSTextAlignment.center
            afternoonEventBtn.setTitleColor(.darkGray, for: UIControl.State())
            afternoonEventBtn.tag = 1
            afternoonEventBtn.addTarget(self, action: #selector(toEditScreen), for: .touchUpInside)
        return afternoonEventBtn
    }()
    lazy var nightButton:UIButton = {
        let nightEventBtn = UIButton()
            nightEventBtn.frame = CGRect(x: self.view.frame.width/10, y: afternoonButton.frame.maxY + dateLabel.frame.height/4, width: self.view.frame.width - self.view.frame.width/5, height: (self.view.frame.maxY - dateLabel.frame.maxY)/5)
            nightEventBtn.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            nightEventBtn.setTitle("Night is nil", for: UIControl.State())
            nightEventBtn.titleLabel?.textAlignment = NSTextAlignment.center
            nightEventBtn.setTitleColor(.darkGray, for: UIControl.State())
            nightEventBtn.tag = 2
            nightEventBtn.addTarget(self, action: #selector(toEditScreen), for: .touchUpInside)
        return nightEventBtn
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
        self.view.addSubview(monthLabel)
        self.view.addSubview(morningButton)
        self.view.addSubview(afternoonButton)
        self.view.addSubview(nightButton)
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
    
    @objc func toEditScreen(sender: UIButton){
        let editScreen = EditViewController()
        editScreen.modalTransitionStyle = .coverVertical
        if sender.tag == 0{
            editScreen.editTime = "Morning"
        }else if sender.tag == 1{
            editScreen.editTime = "Afternoon"
        }else if sender.tag == 2{
            editScreen.editTime = "Night"
        }else{
            editScreen.editTime = "Time is nil"
        }
        self.present(editScreen, animated: true, completion: nil)
    }
    
    func setupRealm(){
        do {
            let realm = try Realm()
            let event = [Event(value:["date":"2018/11/11","time":"Morning","text":"起床する"]),Event(value:["date":"2018/11/10","time":"Afternoon","text":"学校へ行く"]),Event(value:["date":"2018/11/12","time":"Night","text":"寝る"])]
            print("Saving")
            try realm.write {
                realm.deleteAll()
                realm.add(event)
                print("Saved")
            }
        } catch  {
            print("SetUp Error")
        }
    }
    
    func loadEvent(date: String){
        do {
            let realm = try Realm()
            let result = realm.objects(Event.self).filter("date = '\(date)'")
            morningButton.setTitle("Nothing", for: UIControl.State())
            afternoonButton.setTitle("Nothing", for: UIControl.State())
            nightButton.setTitle("Nothing", for: UIControl.State())
            if result.count != 0{
                for ev in result{
                    if ev.time == "Morning"{
                        morningButton.setTitle(ev.text, for: UIControl.State())
                    }else if ev.time == "Afternoon"{
                        afternoonButton.setTitle(ev.text, for: UIControl.State())
                    }else if ev.time == "Night"{
                        nightButton.setTitle(ev.text, for: UIControl.State())
                    }
                }
            }
        } catch  {
            print("Load Error")
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
