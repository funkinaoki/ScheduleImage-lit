//
//  DetailViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit



class DetailViewController: UIViewController, PlanCustomViewTransitionDelegate, EditPlanProtocol{
    
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
        
        startPointDate = detailSchedule.startPoint
        endPointDate = detailSchedule.endPoint
        
        scheduleDistanceDate = Float(DateDifferences.calcDateRemainder(firstDate: endPointDate, secondDate: startPointDate))
        
        alreadyDays.append(detailSchedule.startPoint)
        alreadyDays.append(detailSchedule.endPoint)
        
        startPoint.text = DateUtils.stringFromDate(date: detailSchedule.startPoint, format: "yyyy \n MM/dd")
        endPoint.text = DateUtils.stringFromDate(date: detailSchedule.endPoint, format: "yyyy \n MM/dd")
        topLabel.title = detailSchedule.name
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setPlans()
        }
        
        // 回転の検知を開始
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        // 回転時にセレクタのメソッドを実行する
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange),
                                               name:UIDevice.orientationDidChangeNotification,
                                               object:nil)
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            saveandShare.isHidden = true
            plus.isHidden = true
        case .landscapeRight:
            saveandShare.isHidden = true
            plus.isHidden = true
        default:
            print("tate")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatePlanView" {
            let createPlanView = segue.destination as! CreatePlanViewController
            createPlanView.detailSchedule = detailSchedule
        }
    }
    
//    //これやると遅れてUIが再描画される
//    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
//        switch UIDevice.current.orientation{
//        case .portrait:
//            updateUI()
//            saveandShare.isHidden = false
//            plus.isHidden = false
//        case .landscapeLeft:
//            updateUI()
//            saveandShare.isHidden = true
//            plus.isHidden = true
//        case .landscapeRight:
//            updateUI()
//            saveandShare.isHidden = true
//            plus.isHidden = true
//        default:
//            print("defaults")
//        }
//    }
    
    //一方でこちらはその場で描画してくれるが、真っ直ぐ奥とか色々検知されてしまい、ロードがかかってしまう。
    @objc func orientationDidChange() {
        // 端末の向きを判定
        switch UIDevice.current.orientation {
        case .portrait:
            print("正面")
            updateUI()
            saveandShare.isHidden = false
            plus.isHidden = false
        // 縦の場合（ホームボタンが下に来る向き）
        case .landscapeLeft:
            updateUI()
            saveandShare.isHidden = true
            plus.isHidden = true
        case .landscapeRight:
            updateUI()
            saveandShare.isHidden = true
            plus.isHidden = true
        default:
            break
        }
    }
    
    
    @IBAction func saveAndShare(_ sender: Any) {
        let rect = CGRect(x: 0, y: startPoint.frame.minY - 10 , width: self.view.bounds.width, height: self.view.bounds.height/2 -  startPoint.frame.minY + CGFloat(floorDays.count) * 30 + 10)
        // 共有する項目
        let shareImage = toImage(target: rect)
        
        let activityItems = [shareImage] as [Any]

        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivity.ActivityType.assignToContact
        ]

        activityVC.excludedActivityTypes = excludedActivityTypes
        
        //完了時のアクション
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in

            guard completed else { return }

            switch activityType {
            case UIActivity.ActivityType.saveToCameraRoll:
                //カメラロールに保存してからの処理
                let alert: UIAlertController = UIAlertController(title:"保存", message: "カメラロールに保存しました", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let okAction: UIAlertAction = UIAlertAction(title: "確認", style: UIAlertAction.Style.cancel)
                alert.addAction(okAction)
            default:
                break
            }
        }

        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func toImage(target: CGRect) -> UIImage { // ★target引数追加
        UIGraphicsBeginImageContextWithOptions(target.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()

        context!.translateBy(x: -target.minX, y: -target.minY) // ★一行追加
        self.view.layer.render(in: context!)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }
    
    
    func setPlans () {
        //１日イベントとそうじゃないのは違うロジックで記述します。
        //日数を跨ぐイベント
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
            startPointDistanceDate = Float(DateDifferences.calcDateRemainder(firstDate: startPointPlanDate, secondDate: startPointDate))
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
                
                // ここからendpointLabelの設定
                let endPointPlanLabel = UILabel() // ラベルの生成
                
                endPointPlanLabel.textAlignment = NSTextAlignment.left // 横揃えの設定
                endPointPlanLabel.text = "\(DateUtils.stringFromDate(date:  plansDifferentDate[n].endPoint!, format: "MM/dd"))" //
                endPointPlanLabel.textColor = UIColor.black // テキストカラーの設定
                endPointPlanLabel.font = UIFont(name: "HiraKakuProN-W6", size: 10) // フォントの設定
                
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
            
            customView.delegate = self
            //x座標をハンコ分下げなければならないので、自分のサイズのの半分を計算します。= rect.width / 2
            let frameOneDay = CGSize(width: 500, height: 500)
            let rectOneDay = customView.sizeThatFits(frameOneDay)
            
            customView.frame = CGRect(x: CGFloat(startPointLength) + scheduleView.frame.minX - rectOneDay.width/2,
                                      y: self.view.frame.height/2 - 45,
                                      width: rectOneDay.width,
                                      height: rectOneDay.height)
        
            self.view.addSubview(customView)
            customView.labelModify(plan: plansSameDate[n])
            
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
        //最後だけは被ってもいいから
        result.removeLast()
        return result
    }
    
    //delegateメソッド
    func test(plan: Plan) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let planDetailViewController =  storyboard.instantiateViewController(withIdentifier: "PlanDetailViewController") as! PlanDetailViewController
        planDetailViewController.plan = plan
        planDetailViewController.detailSchedule = detailSchedule
        planDetailViewController.delegate = self
        
        self.present(planDetailViewController, animated: true, completion: nil)
    }
    
    //delegate
    func updateUI() {
        plansSameDate.removeAll()
        plansDifferentDate.removeAll()
        alreadyDays.removeAll()
        floorDays.removeAll()
        allPlansDays.removeAll()
        
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        self.loadView()
        
        database = Database()
        
        startPointDate = detailSchedule.startPoint
        endPointDate = detailSchedule.endPoint
        
        scheduleDistanceDate = Float(DateDifferences.calcDateRemainder(firstDate: endPointDate, secondDate: startPointDate))
        
        
        alreadyDays.append(detailSchedule.startPoint)
        alreadyDays.append(detailSchedule.endPoint)
        
        self.startPoint.text = DateUtils.stringFromDate(date: self.detailSchedule.startPoint, format: "yyyy \n MM/dd")
        self.endPoint.text = DateUtils.stringFromDate(date: self.detailSchedule.endPoint, format: "yyyy \n MM/dd")
        self.topLabel.title = self.detailSchedule.name
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setPlans()
        }

    }
    


}




