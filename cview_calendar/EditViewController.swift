//
//  EditViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/10.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var editDate:String = "nil"
    var editTime:String = "nil"
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
            timelabel.text = "nil"
            timelabel.textColor = .darkGray
            timelabel.text = editTime
            timelabel.textAlignment = NSTextAlignment.center
        return timelabel
    }()
    let textField:UITextField = {
        let textfield = UITextField()
            textfield.frame = CGRect(x: UIScreen.main.bounds.width/8, y: 150, width: UIScreen.main.bounds.width/8 * 6, height: UIScreen.main.bounds.width/3)
            textfield.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 231/255, alpha: 1.0)
        return textfield
    }()
    let updateButton:UIButton = {
        let updateBtn = UIButton()
            updateBtn.frame = CGRect(x:UIScreen.main.bounds.width/6 * 4, y:UIScreen.main.bounds.maxY - UIScreen.main.bounds.height/6, width:UIScreen.main.bounds.width/6, height:UIScreen.main.bounds.width/6)
            updateBtn.backgroundColor = .green
            updateBtn.layer.masksToBounds = true
            updateBtn.layer.cornerRadius = updateBtn.frame.width/2
            updateBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return updateBtn
    }()
    let cancelButton:UIButton = {
        let cancelBtn = UIButton()
            cancelBtn.frame = CGRect(x:UIScreen.main.bounds.width/3 - UIScreen.main.bounds.width/6, y:UIScreen.main.bounds.maxY - UIScreen.main.bounds.height/6, width:UIScreen.main.bounds.width/6, height:UIScreen.main.bounds.width/6)
            cancelBtn.backgroundColor = .red
            cancelBtn.layer.masksToBounds = true
            cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
            cancelBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return cancelBtn
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textField)
        self.view.addSubview(updateButton)
        self.view.addSubview(cancelButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = presentingViewController as! ViewController
        editDate = vc.dateManager.dateToString(date: vc.dateManager.selectedDate, format: "yyyy/MM/dd")
        self.view.backgroundColor = UIColor(red: 255/255, green: 117/255, blue: 195/255, alpha: 1.0)
        self.view.addSubview(dateLabel)
        self.view.addSubview(timeLabel)
    }
    
    @objc func goBack(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
