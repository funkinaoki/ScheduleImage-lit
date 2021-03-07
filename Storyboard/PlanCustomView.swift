//
//  PlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

protocol PlanCustomViewTransitionDelegate {
    func test()
}


class PlanCustomView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftTopBar: UIView!
    @IBOutlet weak var leftDownBar: UIView!
    @IBOutlet weak var rightTopBar: UIView!
    @IBOutlet weak var rightDownBar: UIView!
    
    // デリゲートプロトコルを参照するプロパティ（オプショナルにし、ここでは値を入れない）
    var delegate: PlanCustomViewTransitionDelegate?
    
    
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
        leftTopBar.transform = CGAffineTransform(rotationAngle: .pi * 0.2)
        leftDownBar.transform = CGAffineTransform(rotationAngle: .pi * 0.7)
        
        rightTopBar.transform = CGAffineTransform(rotationAngle: .pi * 0.7)
        rightDownBar.transform = CGAffineTransform(rotationAngle: .pi * 0.2)
    
    }
    
    func actionCloseView(_ sender: DetailViewController) {
        self.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.test()
        print("no")
    }


}
