//
//  GraphViewController.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/14.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    let myColor = color()
    lazy var backButton:UIButton = {
        let backBtn = UIButton()
            backBtn.frame = CGRect(x: self.view.frame.width/3, y: self.view.frame.height/10 * 9, width: self.view.frame.width/3, height: self.view.frame.height/10)
            backBtn.backgroundColor = myColor.colorArray["Pink"]
            backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = myColor.colorArray["Default"]
        self.view.addSubview(backButton)
        
    }
    
    @objc func goBack(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
