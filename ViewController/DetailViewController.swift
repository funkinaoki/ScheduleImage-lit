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
    
    var detailSchedule: Schedule!
    var database: Database!
    var plans: [Plan] = []
    var planNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        startPoint.text = detailSchedule.startPoint
        endPoint.text = detailSchedule.endPoint
        topLabel.title = detailSchedule.name
        setPlans()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatePlanView" {
            let createPlanView = segue.destination as! CreatePlanViewController
            createPlanView.detailSchedule = detailSchedule
        }
    }
    
    func setPlans () {
        //そのスケジュールのプランの数を特定
        plans = database.plans.filter { $0.scheduleID == detailSchedule.id }
        //その回数分viewを呼び出す
        for n in 0..<plans.count {
            var customView = Bundle.main.loadNibNamed("PlanCustomView", owner: self, options: nil)?.first as! PlanCustomView
            customView.frame = CGRect(x: 30,  y: self.view.frame.height/2 + CGFloat(integerLiteral: n * 60 + 3), width: 200, height: 60)
            self.view.addSubview(customView)
            customView.labelModify(name: plans[n].name, startPoint: plans[n].startPoint, endPoint: plans[n].endPoint!)
        }
    }

}
