//
//  Database.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit


final class Database {
    
    var schedules: [Schedule] {
        getSchedulesData()
    }
    
    func setScheduleData(_ helloschedule: Schedule){
        //newschedulesにいああるデータを移行
        var newSchedules = schedules
        //引数のhelloscheduleがデータに既に存在していたら
        if let index = newSchedules.firstIndex(where: { return $0.id == helloschedule.id }) {
            //そのスケジュールを変更
            newSchedules[index] = helloschedule
        } else {
            //そのスケジュールを追加
            newSchedules.append(helloschedule)
        }
        setSchedulesData(newSchedules)
    }
    
}

extension Database {
    private func getSchedulesData() -> [Schedule] {
        guard let items = UserDefaults.standard.array(forKey: "schedules") as? [Data] else { return[] }
        
        let decodedItems = items.map { try! JSONDecoder().decode(Schedule.self, from: $0) }
        print(decodedItems)
        return decodedItems
        
    }
    
    private func setSchedulesData(_ schedules: [Schedule]) {
        let encodedSchedulesData = schedules.map{ try? JSONEncoder().encode($0) }
        UserDefaults.standard.register(defaults: ["schedules": encodedSchedulesData])
    }
}


