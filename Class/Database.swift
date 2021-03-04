//
//  Database.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

enum DatabaseError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
            case .notFound:
                return "該当のデータは見つかりませんでした。"
        }
    }
}

final class Database {
    
    var schedules: [Schedule] {
        getSchedulesData()
    }
    
    var plans: [Plan] {
        getPlansData()
    }

    
    func setScheduleData(_ helloSchedule: Schedule) {
        //newschedulesにいああるデータを移行
        var newSchedules = schedules
        //引数のhelloscheduleがデータに既に存在していたら
        if let index = newSchedules.firstIndex(where: { return $0.id == helloSchedule.id }) {
            //そのスケジュールを変更
            newSchedules[index] = helloSchedule
        } else {
            //そのスケジュールを追加
            newSchedules.append(helloSchedule)
        }
        setSchedulesData(newSchedules)
    }
    
    func setPlanData(_ helloPlan: Plan) {
        var newPlans = plans
        if let index = newPlans.firstIndex(where: { return $0.id == helloPlan.id}) {
            newPlans[index] = helloPlan
        } else {
            newPlans.append(helloPlan)
        }
        setPlansData(newPlans)
    }
    
    func deleteScheduleData(_ helloSchedule: Schedule) throws {
        var newSchedules = schedules
        if let index = newSchedules.firstIndex(where: { return $0.id == helloSchedule.id }) {
            newSchedules.remove(at: index)
            setSchedulesData(newSchedules)
        } else {
            throw DatabaseError.notFound
        }
    }
    
    func deletePlanData(_ helloPlan: Plan) throws {
        var newPlans = plans
        if let index = newPlans.firstIndex(where: { return $0.id == helloPlan.id }) {
            newPlans.remove(at: index)
            setPlansData(newPlans)
        } else {
            throw DatabaseError.notFound
        }
    }
    
    func changeScheduleOrder(helloSchedule: Schedule,destinationIndex: Int) throws {
        var newSchedules = schedules
        if let index = newSchedules.firstIndex(where: { return $0.id == helloSchedule.id }) {
            newSchedules.remove(at: index)
            newSchedules.insert(helloSchedule, at: destinationIndex)
            setSchedulesData(newSchedules)
        } else {
            throw DatabaseError.notFound
        }
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
        UserDefaults.standard.set(encodedSchedulesData as [Any], forKey: "schedules")
    }
    
    private func getPlansData() -> [Plan] {
        guard let items = UserDefaults.standard.array(forKey: "plans") as? [Data] else { return[] }
        let decodedItems = items.map { try! JSONDecoder().decode(Plan.self, from: $0) }
        return decodedItems
        
    }
    
    private func setPlansData(_ plans: [Plan]) {
        let encodedPlansData = plans.map{ try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(encodedPlansData as [Any], forKey: "plans")
    }
    
}


