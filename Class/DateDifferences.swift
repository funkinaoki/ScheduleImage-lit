//
//  DateDifferences.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/10.
//

import Foundation

class DateDifferences{
    class func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
    
    class func calcDateRemainder(firstDate: Date, secondDate: Date) -> Int{

        var retInterval:Double!
        let firstDateReset = DateDifferences.resetTime(date: firstDate)

        let secondDateReset: Date = DateDifferences.resetTime(date: secondDate)
        retInterval = firstDateReset.timeIntervalSince(secondDateReset)

        let ret = retInterval/86400

        return Int(floor(ret))  // n日
    }
    
    class func roundDate(_ date: Date, calendar: Calendar) -> Date {
    return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: date)!
    }
    
}
