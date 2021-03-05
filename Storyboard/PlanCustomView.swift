//
//  PlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

class PlanCustomView: UIView {

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
    
    func actionCloseView(_ sender: DetailViewController) {
        self.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mainVC = MainViewController()
        
    }


}
