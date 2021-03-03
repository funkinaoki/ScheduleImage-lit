//
//  PlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

class PlanCustomView: UIView {

    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    func initView(){

    }
    
    func labelModify(name: String, startPoint: Date, endPoint: Date) {
        nameLabel.text = name
        startPointLabel.text = DateUtils.stringFromDate(date: startPoint, format: "MM/dd")
        endPointLabel.text = DateUtils.stringFromDate(date: endPoint, format: "MM/dd")
    }
    
    @IBAction func actionCloseView(_ sender: Any) {
        self.removeFromSuperview()
    }

    


}
