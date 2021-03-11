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
    @IBOutlet weak var wakuLine: UILabel!
    @IBOutlet weak var backGroundColor: UIView!
    
    var database: Database!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        database = Database()
        self.wakuLine.layer.borderWidth = 1.0
        self.wakuLine.layer.borderColor = UIColor(red: 0.243351, green: 0.368068, blue: 0.349043, alpha: 1.0).cgColor
        self.wakuLine.layer.cornerRadius = 10.0
        self.wakuLine.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            //押下時のセルの処理
            backGroundColor.backgroundColor = UIColor.lightGray
        }else{
            backGroundColor.backgroundColor = UIColor.clear
        }

    }
    
    func setCell(schedule: Schedule){
        self.startPointLabel.text = DateUtils.stringFromDate(date: schedule.startPoint, format: "yyyy/MM/dd") as String
        self.endPointLabel.text = DateUtils.stringFromDate(date: schedule.endPoint, format: "yyyy/MM/dd") as String
        self.nameLabel.text = schedule.name as String
    }
    
}
