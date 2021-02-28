//
//  DateUtills.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

class DateUtils {
    class func dateFromString(string: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: string)!
    }
    
    class func stringFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }

}

