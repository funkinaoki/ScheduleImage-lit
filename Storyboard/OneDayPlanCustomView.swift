//
//  OneDayPlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/04.
//

import UIKit

class OneDayPlanCustomView: UIView {
    
    var delegate: PlanCustomViewTransitionDelegate?
    var thisPlan: Plan!
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

    func labelModify(plan: Plan) {
        nameLabel.text = plan.name
        thisPlan = plan
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
 
        delegate?.test(plan: thisPlan)
    }
    

}
