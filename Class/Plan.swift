//
//  Plan.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

struct Plan: Codable{
    var id = UUID()
    var name: String!
    var startPoint: Date!
    var endPoint: Date!
    var floor: Int = 0
    var distanceDate: Float!
    var scheduleID: UUID!
    
    func save() {
        let database = Database()
        database.setPlanData(self)
    }
}
