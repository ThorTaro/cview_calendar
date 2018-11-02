//
//  DateManager.swift
//  cview_calendar
//
//  Created by Taro on 2018/11/02.
//  Copyright © 2018 Taro. All rights reserved.
//

import UIKit

class DateManager: NSObject{
    var currentMonthOfDates = [Date]() // 表示する月の日にちを格納する配列
    var selectedDate = Date()
    let daysPerWeek: Int = 7
    var numberOfItems:Int = 0 // セルの個数
    
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
    
    // 選択した月の初日をDate型で返すメソッド
    func firstDateOfMonth() -> Date{
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
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
    
    // String型へ変換メソッド
    func conversionDateFormat(indexPath: IndexPath) -> String{
        dateForCellAtIndexPath(numberOfItem: numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        
        return formatter.string(from: currentMonthOfDates[indexPath.row])
    }
    
    func prevMonth(_ date: Date) -> Date{
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        let testformatter:DateFormatter = DateFormatter()
        testformatter.dateFormat = "yyyy/MM/dd HH:mm"
        print(testformatter.string(from: selectedDate))
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
}
