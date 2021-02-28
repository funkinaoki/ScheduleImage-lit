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
    var startPoint: String!
    var endPoint: String!
    
    func save() {
        let database = Database()
        database.setScheduleData(self)
    }
}
