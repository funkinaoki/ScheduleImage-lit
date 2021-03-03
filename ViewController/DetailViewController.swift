//
//  DetailViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var startPoint: UILabel!
    @IBOutlet weak var endPoint: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var saveandShare: UIButton!
    @IBOutlet weak var topLabel: UINavigationItem!
    @IBOutlet weak var scheduleView: UIView!
    
    var detailSchedule: Schedule!
    var database: Database!
    var plans: [Plan] = []
    var beforePlans: [Plan] = []
    var planNumber: Int!
    
    
    var startPointDate: Date!
    var endPointDate: Date!
    var scheduleDistanceDate: Float!
    
    var startPointPlanDate: Date!
    var endPointPlanDate: Date!
    
    var lengthRatio: Float!
    var planLength: Float!
    
    var startPointDistanceDate: Float!
    var startPointRatio: Float!
    var startPointLength: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        startPoint.text = DateUtils.stringFromDate(date: detailSchedule.startPoint)
        endPoint.text = DateUtils.stringFromDate(date: detailSchedule.endPoint)
        topLabel.title = detailSchedule.name
        
        startPointDate = detailSchedule.startPoint
        endPointDate = detailSchedule.endPoint
        
        scheduleDistanceDate = Float(Calendar.current.dateComponents([.day], from: startPointDate, to: endPointDate).day!)
        
        setPlans()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatePlanView" {
            let createPlanView = segue.destination as! CreatePlanViewController
            createPlanView.detailSchedule = detailSchedule
        }
    }
    
    func setPlans () {
        //そのスケジュールのプランを特定
        plans = database.plans.filter { $0.scheduleID == detailSchedule.id }
        plans.sort(by: {$0.distanceDate < $1.distanceDate})
        //その回数分viewを呼び出す
        for n in 0..<plans.count {
            let customView = Bundle.main.loadNibNamed("PlanCustomView", owner: self, options: nil)?.first as! PlanCustomView
            
            //planの開始日と終了日を定義するよー
            startPointPlanDate = plans[n].startPoint
            endPointPlanDate = plans[n].endPoint
            
            //ここからplanの長さを定義するよー
            lengthRatio = plans[n].distanceDate / scheduleDistanceDate
            planLength = Float(scheduleView.frame.width) * lengthRatio
            
            //ここからplanの開始点を定義するよー
            startPointDistanceDate = Float(Calendar.current.dateComponents([.day], from: startPointDate, to: startPointPlanDate).day!)
            startPointRatio = startPointDistanceDate / scheduleDistanceDate
            startPointLength = Float(scheduleView.frame.width) * startPointRatio
            
                
            customView.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX,  y: self.view.frame.height/2 + CGFloat(integerLiteral: n * 50 + 3), width: CGFloat(planLength), height: 50)
        
            self.view.addSubview(customView)
            customView.labelModify(name: plans[n].name, startPoint: plans[n].startPoint, endPoint: plans[n].endPoint)
        }
    }

}
