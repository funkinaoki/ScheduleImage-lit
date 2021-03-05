//
//  OneDayPlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/04.
//

import UIKit

class OneDayPlanCustomView: UIView {
    
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

    func labelModify(name: String) {
        nameLabel.text = name
    }

    @IBAction func actionCloseView(_ sender: Any) {
        self.removeFromSuperview()
    }

}
