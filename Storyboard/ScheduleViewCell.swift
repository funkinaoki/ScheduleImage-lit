//
//  ScheduleViewCell.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

class ScheduleViewCell: UITableViewCell {
    
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var database: Database!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        database = Database()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell(schedule: Schedule){
        self.startPointLabel.text = schedule.startPoint as String
        self.endPointLabel.text = schedule.endPoint as String
        self.nameLabel.text = "”" + schedule.name + "”" as String
    }
    
}
