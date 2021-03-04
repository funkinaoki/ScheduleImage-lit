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
    var allPlansDays: [[String]] = []
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
    
    var floorDays: [[String]] = [] //変数の中に、階層⇨alldate //そのフロアにおける埋まってる日付
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        startPoint.text = DateUtils.stringFromDate(date: detailSchedule.startPoint, format: "yyyy/MM/dd")
        endPoint.text = DateUtils.stringFromDate(date: detailSchedule.endPoint, format: "yyyy/MM/dd")
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
        
        //全てのplanの日にちを取得する。⇨allplandaysにplans[n]の日にち全てが入っている⇨それをallplansDaysという二重配列にappendする。例えばallPlansDays[0]は一個目のplanの日付の全てが入ってる
        for n in 0..<plans.count {
            let allPlanDays = getDaysArray(startPoint: plans[n].startPoint, endPoint: plans[n].endPoint, max: 1000)
            allPlansDays.append(allPlanDays)
            
        }
        
        //ここからfloor
        if plans.count > 0 {
            for n in 0..<plans.count { //n = plans[0]を除いたplan
                for (z,_) in floorDays.enumerated() { //これを階層分続ける
                    for_x: for x in allPlansDays[n] { //自分と
                        for y in floorDays[z] { //一番低い階層
                            if x == y { //日付が被ってたら
                                plans[n].floor = z + 1 //階層を今のfor文の階層に変える
                                break for_x
                            }
                        }
                    }
                }
                //やっとfloorと被らなくなり、地獄のfloorfor文を抜け出せても仕事が残っているぞおお
                //１、それは自分の階層データが存在しなければ追加すること
                if floorDays.count - 1 < plans[n].floor {
                    let floor: [String] = [] //自分階層つくるぞ！！！
                    floorDays.append(floor) //階層を取り仕切ってるボスに報告しよう
                }
                floorDays[plans[n].floor].append(contentsOf: allPlansDays[n]) //２、自分の階層の配列に自分の日付を追加する。
            }
        }
        
        
//        for n in 0..<plans.count {
//            print(plans[n].floor)
//        }
        
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
            
                
            customView.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX,
                                      y: self.view.frame.height/2 + CGFloat(integerLiteral: plans[n].floor * 50 + 3),
                                      width: CGFloat(planLength),
                                      height: 50)
            
            print(planLength!)
            print(Float(scheduleView.frame.width))
        
            self.view.addSubview(customView)
            customView.labelModify(name: plans[n].name, startPoint: plans[n].startPoint, endPoint: plans[n].endPoint)
        }
    }
    
    func getDaysArray(startPoint:Date, endPoint:Date, max:Int) -> [String] {

        var result:[String] = []

        let endStr = DateUtils.stringFromDate(date: endPoint, format: "yyyy/MM/dd")

        var components = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        for i in 0 ..< max {

            components.setValue(i,for: Calendar.Component.day)
            let wk = calendar.date(byAdding: components, to: startPoint)!
            let wkStr = DateUtils.stringFromDate(date: wk, format: "yyyy/MM/dd")
            if wkStr > endStr {
                break
            } else {
                result.append(wkStr)
            }
        }
        result.removeFirst()
        result.removeLast()
        return result
    }

}
