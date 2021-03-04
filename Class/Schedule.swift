//
//  Schedule.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

struct Schedule: Codable{
    var id = UUID()
    var name: String!
    var startPoint: Date!
    var endPoint: Date!
    
    func save() {
        let database = Database()
        database.setScheduleData(self)
    }
    
    func delete() {
        let database = Database()
        do {
            try database.deleteScheduleData(self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func changeOrder(destinationIndex: Int) {
        let database = Database()
        do {
            try database.changeScheduleOrder(helloSchedule: self, destinationIndex: destinationIndex)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
