//
//  DateManager.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/02.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit
import RealmSwift

class DateManager: NSObject{
    let formatter: DateFormatter = DateFormatter()
    var currentMonthOfDates = [Date]() // 表示する月の日にちを格納する配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems:Int = 0 // セルの個数
    
    override init(){
        super.init()
        dateForCellAtIndexPath(numberOfItem: daysAcquisition())
    }
    
    // 表示するセルの個数を計算するメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth() as Date)
        guard  let unwrapedRangeOfWeeks = rangeOfWeeks else {
            return numberOfItems
        }
        let numberOfWeeks = unwrapedRangeOfWeeks.count
        numberOfItems = numberOfWeeks * daysPerWeek
        return numberOfItems
    }
    
    func firstDateOfMonth() -> Date{
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    func indexOfselectedDate() -> Int{
        let indexOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())! - 1
        formatter.dateFormat = "d"
        let indexOfselectedDate: String = formatter.string(from: selectedDate)
        return Int(indexOfselectedDate)! + indexOfFirstDay - 1
    }
    
    // numberOfItemsの数だけ日にちを格納する(先月と来月の日にちも含む)
    func dateForCellAtIndexPath(numberOfItem: Int){
        // 月の初日の曜日を取得する(.dayは実際のところ.weekday)
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        
        for i in 0 ..< numberOfItems{
            var dateComponents = DateComponents()
            // 参照しているセル番地と月の初日の曜日がどれだけ離れているのかを計算(曜日の関係上1を足している)
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            let date = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth() as Date)!
            
            currentMonthOfDates.append(date)
        }
    }
    
    func getDaysOfMonth() -> Array<String>{
        let range:Range<Int> = Calendar.current.range(of: .day, in: .month, for: selectedDate as Date) ?? 0..<1
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate as Date)
        var dateArray = [String]()
        for i in range{
            components.day = i
            dateArray.append(dateToString(date: Calendar.current.date(from: components)!, format: "yyyy/MM/dd"))
        }
        return dateArray
    }
    
    
    func conversionDateFormat(indexPath: Int, format: String) -> String{
        formatter.dateFormat = format
        return formatter.string(from: currentMonthOfDates[indexPath])
    }
    
    func dateToString(date: Date, format: String) -> String{
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func prevMonth(_ date: Date) -> Date{
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    
    func nextMonth(_ date: Date) -> Date{
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
    
        return selectedDate
    }
}

extension Date{
    func monthAgoDate() -> Date{
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
    func monthLaterDate() -> Date{
        let addValue = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents, to: self)!
    }
}
