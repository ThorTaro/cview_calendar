//
//  RealmData.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/05.
//  Copyright © 2018 Taro. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var color: String = "Default"
}

/*
 DBのファイルの場所
 print(Realm.Configuration.defaultConfiguration.fileURL!)
*/
