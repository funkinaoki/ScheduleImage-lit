//
//  PlanCustomView.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

protocol PlanCustomViewTransitionDelegate: UIViewController {
    func test()
}

class PlanCustomView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    
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
    }
    
    func actionCloseView(_ sender: DetailViewController) {
        self.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.test()
        guard let delegate = delegate else {
                    // 処理を任せる相手が決まっていない場合
                    print("No Person")
                    return
        }
        if type(of: delegate) == DetailViewController.self {
                    // 処理を任せる相手がJohnクラスの場合
                    // 挨拶と名前をログに出力
                    delegate.test()
        }
//        delegate?.toPlanDetailView()
        print("no")
//        let storyboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
//        let DetailViewController =  storyboard.instantiateViewController(withIdentifier: "Detail")
//        //現在画面表示を担当しているViewControllerインスタンスに対して`present(_:animated:completion:)`メソッドを呼ぶ
//        owner?.present(DetailViewController, animated: true, completion: nil)
        
        
    }


}
