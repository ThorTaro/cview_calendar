//
//  EditViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/10.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    let myColor = color()
    var editDate:String = "nil"
    var editTime:String = "nil"
    var editText:String = "nil"
    var themeColor:String = "Default"
    lazy var dateLabel:UILabel = {
        let datelabel = UILabel()
            datelabel.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 35, width: UIScreen.main.bounds.width/2, height: 40)
            datelabel.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            datelabel.text = "nil"
            datelabel.textColor = .darkGray
            datelabel.text = editDate
            datelabel.textAlignment = NSTextAlignment.center
        return datelabel
    }()
    lazy var timeLabel:UILabel = {
        let timelabel = UILabel()
            timelabel.frame = CGRect(x: UIScreen.main.bounds.width/4, y: dateLabel.frame.maxY, width: UIScreen.main.bounds.width/2, height: 40)
            timelabel.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            timelabel.textColor = .darkGray
            timelabel.text = editTime
            timelabel.textAlignment = NSTextAlignment.center
        return timelabel
    }()
    lazy var textField:UITextField = {
        let textfield = UITextField()
            textfield.frame = CGRect(x: UIScreen.main.bounds.width/8, y: 150, width: UIScreen.main.bounds.width/8 * 6, height: UIScreen.main.bounds.width/3)
            textfield.backgroundColor = .white
            textfield.text = "nil"
            textfield.delegate = self
            textfield.clearButtonMode = .always
            textfield.returnKeyType = .done
        return textfield
    }()
    let updateButton:UIButton = {
        let updateBtn = UIButton()
            updateBtn.frame = CGRect(x:UIScreen.main.bounds.width/6 * 4, y:UIScreen.main.bounds.maxY - UIScreen.main.bounds.height/6, width:UIScreen.main.bounds.width/6, height:UIScreen.main.bounds.width/6)
            updateBtn.backgroundColor = .green
            updateBtn.layer.masksToBounds = true
            updateBtn.layer.cornerRadius = updateBtn.frame.width/2
            updateBtn.addTarget(self, action: #selector(update), for: .touchUpInside)
        return updateBtn
    }()
    let cancelButton:UIButton = {
        let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x:UIScreen.main.bounds.width/3 - UIScreen.main.bounds.width/6, y:UIScreen.main.bounds.maxY - UIScreen.main.bounds.height/6, width:UIScreen.main.bounds.width/6, height:UIScreen.main.bounds.width/6)
            cancelBtn.backgroundColor = .red
            cancelBtn.layer.masksToBounds = true
            cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
            cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelBtn
    }()
    lazy var colors:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colorCView = UICollectionView(frame:CGRect(x: textField.frame.minX, y: textField.frame.maxY + 50, width: textField.frame.width, height: textField.frame.width/6 * 2), collectionViewLayout:layout)
            colorCView.register(colorCell.self, forCellWithReuseIdentifier: "colorCell")
            colorCView.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
            colorCView.dataSource = self
            colorCView.delegate = self
            layout.itemSize = CGSize(width: colorCView.frame.width/6 - 2, height: colorCView.frame.width/6 - 2)
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 0
        return colorCView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textField)
        self.view.addSubview(colors)
        self.view.addSubview(updateButton)
        self.view.addSubview(cancelButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = presentingViewController as! ViewController
        editDate = vc.dateManager.dateToString(date: vc.dateManager.selectedDate, format: "yyyy/MM/dd")
        self.view.addSubview(dateLabel)
        self.view.addSubview(timeLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.endEditing(true)
    }
    
    @objc func cancel(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func update(sender: UIButton){
        editText = textField.text ?? " "
        do {
            let realm = try Realm()
            let result = realm.objects(Event.self).filter("date = '\(editDate)' && time = '\(editTime)'")
            if result.count != 0 {
                try! realm.write {
                    result.last?.text = editText
                    result.last?.color = themeColor
                }
            } else{
                let event = Event(value:["date":editDate, "time":editTime, "text":editText, "color":themeColor])
                try! realm.write {
                    realm.add(event)
                }
            }
        } catch  {
            print("Realm loading error at edit screen")
        }
        (presentingViewController as! ViewController).loadEvent(date: editDate)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("Text clear")
        return true
    }
}

extension EditViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:colorCell = colors.cellForItem(at: indexPath) as! colorCell
        self.view.backgroundColor = cell.cellColor.colorArray[cell.myColor]
        themeColor = cell.myColor
    }
    
}

extension EditViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:colorCell = colors.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! colorCell
        cell.myColor = cell.cellColor.colorName[indexPath.row]
        cell.setColor()
        return cell
    }
}
