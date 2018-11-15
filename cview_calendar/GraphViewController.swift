//
//  GraphViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/14.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewController: UIViewController {
    let myColor = color()
    let numberOftimes:CGFloat = 3
    var denominator:CGFloat = 0
    lazy var colorRate:[String:CGFloat] = {
        var colorrate:[String:CGFloat] = [:]
        for name in myColor.colorName{
            colorrate[name] = 0.0
        }
        return colorrate
    }()
    lazy var backButton:UIButton = {
        let backBtn = UIButton()
            backBtn.frame = CGRect(x: self.view.frame.width/3, y: self.view.frame.height/10 * 9, width: self.view.frame.width/3, height: self.view.frame.height/10)
            backBtn.backgroundColor = myColor.colorArray["Pink"]
            backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(backButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let numberOfDays:Array<String> = (presentingViewController as! ViewController).dateManager.getDaysOfMonth()
        calculate(month: numberOfDays)
        makeCircle()
    }
    
    @objc func goBack(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    func calculate(month:Array<String>){
        denominator = numberOftimes * CGFloat(month.count)
        colorRate["Default"] = denominator
        do {
            let realm = try Realm()
            for date in month{
                let result = realm.objects(Event.self).filter("date = '\(date)'")
                for ev in result{
                    if ev.color != "Default"{
                        colorRate[ev.color]! += 1
                        colorRate["Default"]! -= 1
                    }
                }

            }
        } catch {
            print("Load Error")
        }
    }
    
    func makeCircle(){
        var startAngle:CGFloat = CGFloat(Double.pi)/2 * 3
        var endAngle:CGFloat = 0.0
        for color in myColor.colorName{
            let rate:CGFloat = colorRate[color]!/denominator
            endAngle = (CGFloat(Double.pi) * 2.0 * rate) + startAngle
            self.view.layer.insertSublayer(makeArc(color: color, startAngle: startAngle, endAngle: endAngle), at: 0)
            startAngle = endAngle
        }
    }
    
    func makeArc(color:String, startAngle:CGFloat, endAngle:CGFloat) -> CAShapeLayer{
        let arc = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2), radius: (self.view.frame.width/10 * 8)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arc.addLine(to: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2))
        let layer = CAShapeLayer()
        layer.fillColor = myColor.colorArray[color]?.cgColor
        layer.path = arc.cgPath
        return layer
    }
}
