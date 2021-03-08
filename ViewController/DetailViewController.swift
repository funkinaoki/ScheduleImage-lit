//
//  DetailViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit



class DetailViewController: UIViewController, PlanCustomViewTransitionDelegate{
    
    @IBOutlet weak var startPoint: UILabel!
    @IBOutlet weak var endPoint: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var saveandShare: UIButton!
    @IBOutlet weak var topLabel: UINavigationItem!
    @IBOutlet weak var scheduleView: UIView!
    
    var detailSchedule: Schedule!
    var database: Database!
    var plansDifferentDate: [Plan] = []
    var plansSameDate: [Plan] = []
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
    var alreadyDays: [Date] = []
//    let planCustom = PlanCustomView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        startPoint.text = DateUtils.stringFromDate(date: detailSchedule.startPoint, format: "yyyy \n MM/dd")
        endPoint.text = DateUtils.stringFromDate(date: detailSchedule.endPoint, format: "yyyy \n MM/dd")
        topLabel.title = detailSchedule.name
        
        startPointDate = detailSchedule.startPoint
        endPointDate = detailSchedule.endPoint
        
        scheduleDistanceDate = Float(Calendar.current.dateComponents([.day], from: startPointDate, to: endPointDate).day!)
        
        alreadyDays.append(detailSchedule.startPoint)
        alreadyDays.append(detailSchedule.endPoint)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPlans()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        floorDays.removeAll()

        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        self.loadView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatePlanView" {
            let createPlanView = segue.destination as! CreatePlanViewController
            createPlanView.detailSchedule = detailSchedule
        }
    }
    
    @IBAction func saveAndShare(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let planDetailViewController =  storyboard.instantiateViewController(withIdentifier: "PlanDetailViewController")
        self.present(planDetailViewController, animated: true, completion: nil)
    }
    
    func setPlans () {
        //１日イベントとそうじゃないのは違うロジックで記述します。
        //そうじゃないの
        plansDifferentDate = database.plans.filter { $0.scheduleID == detailSchedule.id && $0.startPoint != $0.endPoint}
        plansDifferentDate.sort(by: {$0.distanceDate < $1.distanceDate})
        
        //１日イベント
        plansSameDate = database.plans.filter { $0.scheduleID == detailSchedule.id && $0.startPoint == $0.endPoint}
        plansSameDate.sort(by: {$0.distanceDate < $1.distanceDate})
        
        //全てのplanの日にちを取得する。⇨allplandaysにplans[n]の日にち全てが入っている⇨それをallplansDaysという二重配列にappendする。例えばallPlansDays[0]は一個目のplanの日付の全てが入ってる
        for n in 0..<plansDifferentDate.count {
            let allPlanDays = getDaysArray(startPoint: plansDifferentDate[n].startPoint, endPoint: plansDifferentDate[n].endPoint, max: 1000)
            allPlansDays.append(allPlanDays)
        }
        
        //ここからfloor
        if plansDifferentDate.count > 0 {
            for n in 0..<plansDifferentDate.count {
                for (z,_) in floorDays.enumerated() { //これを階層分続ける
                    for_x: for x in allPlansDays[n] { //自分と
                        for y in floorDays[z] { //一番低い階層
                            if x == y { //日付が被ってたら
                                plansDifferentDate[n].floor = z + 1 //階層を今のfor文の階層に変える
                                break for_x
                            }
                        }
                    }
                }
                
                print(plansDifferentDate[n].floor)
                //やっとfloorと被らなくなり、地獄のfloorfor文を抜け出せても仕事が残っているぞおお
                //１、それは自分の階層データが存在しなければ追加すること
                if floorDays.count - 1 < plansDifferentDate[n].floor {
                    let floor: [String] = [] //自分階層つくるぞ！！！
                    floorDays.append(floor) //階層を取り仕切ってるボスに報告しよう
                }
                floorDays[plansDifferentDate[n].floor].append(contentsOf: allPlansDays[n]) //２、自分の階層の配列に自分の日付を追加する。
            }
        }
        
        
        //１日イベント以外のpurannwo回数分viewを呼び出す
        for n in 0..<plansDifferentDate.count {
            
            //planの開始日と終了日を定義するよー
            startPointPlanDate = plansDifferentDate[n].startPoint
            endPointPlanDate = plansDifferentDate[n].endPoint
            
            //ここからplanの長さを定義するよー
            lengthRatio = plansDifferentDate[n].distanceDate / scheduleDistanceDate
            planLength = Float(scheduleView.frame.width) * lengthRatio
            
            //ここからplanの開始点を定義するよー
            startPointDistanceDate = Float(Calendar.current.dateComponents([.day], from: startPointDate, to: startPointPlanDate).day!)
            startPointRatio = startPointDistanceDate / scheduleDistanceDate
            startPointLength = Float(scheduleView.frame.width) * startPointRatio
            
                
            let customView = Bundle.main.loadNibNamed("PlanCustomView", owner: self, options: nil)?.first as! PlanCustomView
            customView.delegate = self
            
            customView.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX,
                                      y: self.view.frame.height/2 + CGFloat(integerLiteral: plansDifferentDate[n].floor * 30 + 3),
                                      width: CGFloat(planLength),
                                      height: 30)
        
            self.view.addSubview(customView)
            customView.labelModify(plan: plansDifferentDate[n])
            
            ///ここからUILabelの設定
            
            //labelの設定
            
            if !alreadyDays.contains(plansDifferentDate[n].startPoint) {
                
            
                let startPointPlanLabel = UILabel() // ラベルの生成
                
                startPointPlanLabel.textAlignment = NSTextAlignment.left // 横揃えの設定
                startPointPlanLabel.text = "\(DateUtils.stringFromDate(date:  plansDifferentDate[n].startPoint!, format: "MM/dd"))" // テキストの設定
                startPointPlanLabel.textColor = UIColor.black // テキストカラーの設定
                startPointPlanLabel.font = UIFont(name: "HiraKakuProN-W6", size: 10) // フォントの設定
    //                startPointPlanLabel.backgroundColor = UIColor.lightGray
                
                //x座標をハンコ分下げなければならないので、自分のサイズのの半分を計算します。= rect.width / 2
                let frameStart = CGSize(width: 200, height: 200)
                let rectStart = startPointPlanLabel.sizeThatFits(frameStart)
                
                startPointPlanLabel.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - rectStart.width / 2, y: self.view.frame.height/2 - 14 , width: rectStart.width, height: rectStart.height) // 位置とサイズの指定
                
                self.view.addSubview(startPointPlanLabel) // ラベルの追加
                alreadyDays.append(plansDifferentDate[n].startPoint) //自分の追加
                
                //dotの追加
                let startPointDot = UIImageView(image: UIImage(systemName: "circle.fill"))
                startPointDot.tintColor = UIColor.black
                
                
                startPointDot.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - 5, y: self.view.frame.height/2 - 5, width: 10, height: 10)
                
                self.view.addSubview(startPointDot)
                
            
            }
            
            if !alreadyDays.contains(plansDifferentDate[n].endPoint) {
                // ここからendpointの設定
                let endPointPlanLabel = UILabel() // ラベルの生成
                
                endPointPlanLabel.textAlignment = NSTextAlignment.left // 横揃えの設定
                endPointPlanLabel.text = "\(DateUtils.stringFromDate(date:  plansDifferentDate[n].endPoint!, format: "MM/dd"))" // テキストの設定
                endPointPlanLabel.textColor = UIColor.black // テキストカラーの設定
                endPointPlanLabel.font = UIFont(name: "HiraKakuProN-W6", size: 10) // フォントの設定
    //          startPointPlanLabel.backgroundColor = UIColor.lightGray
                
                //x座標をハンコ分下げなければならないので、自分のサイズのの半分を計算します。= rect.width / 2
                let frameEnd = CGSize(width: 200, height: 200)
                let rectEnd = endPointPlanLabel.sizeThatFits(frameEnd)
                
                endPointPlanLabel.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - rectEnd.width / 2 + CGFloat(planLength), y: self.view.frame.height/2 - 14 , width: rectEnd.width, height: rectEnd.height) // 位置とサイズの指定
                
                self.view.addSubview(endPointPlanLabel) // ラベルの追加
                
                
                alreadyDays.append(plansDifferentDate[n].endPoint)
                
                //dotの追加
                let endPointDot = UIImageView(image: UIImage(systemName: "circle.fill"))
                endPointDot.tintColor = UIColor.black
                
                
                endPointDot.frame = CGRect(x: CGFloat(startPointLength) + CGFloat(planLength) + scheduleView.frame.minX - 5, y: self.view.frame.height/2 - 5, width: 10, height: 10)
                
                // UIImageViewを追加
                self.view.addSubview(endPointDot)
                
            }
        }
        
        ///１日イベント
        for n in 0..<plansSameDate.count {
            //planの開始日と終了日を定義するよー
            startPointPlanDate = plansSameDate[n].startPoint
            endPointPlanDate = plansSameDate[n].endPoint
            
            //ここからplanの長さを定義するよー
            lengthRatio = plansSameDate[n].distanceDate / scheduleDistanceDate
            planLength = Float(scheduleView.frame.width) * lengthRatio
            
            //ここからplanの開始点を定義するよー
            startPointDistanceDate = Float(Calendar.current.dateComponents([.day], from: startPointDate, to: startPointPlanDate).day!)
            startPointRatio = startPointDistanceDate / scheduleDistanceDate
            startPointLength = Float(scheduleView.frame.width) * startPointRatio
            
                
            let customView = Bundle.main.loadNibNamed("OneDayPlanCustomView", owner: self, options: nil)?.first as! OneDayPlanCustomView
            //x座標をハンコ分下げなければならないので、自分のサイズのの半分を計算します。= rect.width / 2
            let frameOneDay = CGSize(width: 500, height: 500)
            let rectOneDay = customView.sizeThatFits(frameOneDay)
            
            customView.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - rectOneDay.width/2,
                                      y: self.view.frame.height/2 - 50,
                                      width: rectOneDay.width,
                                      height: rectOneDay.height)
        
            self.view.addSubview(customView)
            customView.labelModify(name: plansSameDate[n].name)
            
            //すでにその日付があったらそのラベルは要らない
            if !alreadyDays.contains(plansSameDate[n].startPoint) {
            
                //UILABEL
                //startPointの設定
                let startPointPlanLabel = UILabel() // ラベルの生成
                
                startPointPlanLabel.textAlignment = NSTextAlignment.left // 横揃えの設定
                startPointPlanLabel.text = "\(DateUtils.stringFromDate(date:  plansSameDate[n].startPoint!, format: "MM/dd"))" // テキストの設定
                startPointPlanLabel.textColor = UIColor.black // テキストカラーの設定
                startPointPlanLabel.font = UIFont(name: "HiraKakuProN-W6", size: 10) // フォントの設定
                
                //x座標をハンコ分下げなければならないので、自分のサイズのの半分を計算します。= rect.width / 2
                let frameStart = CGSize(width: 200, height: 200)
                let rectStart = startPointPlanLabel.sizeThatFits(frameStart)
                
                startPointPlanLabel.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - rectStart.width / 2, y: self.view.frame.height/2 - 14 , width: rectStart.width, height: rectStart.height) // 位置とサイズの指定
                
                self.view.addSubview(startPointPlanLabel) // ラベルの追加
                alreadyDays.append(plansSameDate[n].startPoint)
                
                
                //dotの追加
                let oneDayStartPointDot = UIImageView(image: UIImage(systemName: "circle.fill"))
                oneDayStartPointDot.tintColor = UIColor.black
                
                oneDayStartPointDot.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - 5, y: self.view.frame.height/2 - 5, width: 10, height: 10)
                
                self.view.addSubview(oneDayStartPointDot)
            }
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
        
        if result.count != 3 {
            result.removeLast()
        }
        return result
    }
    
    //delegateメソッド
    func test(plan: Plan) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let planDetailViewController =  storyboard.instantiateViewController(withIdentifier: "PlanDetailViewController") as! PlanDetailViewController
        planDetailViewController.plan = plan
        planDetailViewController.detailSchedule = detailSchedule
        self.present(planDetailViewController, animated: true, completion: nil)
    }
    


}




