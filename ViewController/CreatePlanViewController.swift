//
//  CreatePlanViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

class CreatePlanViewController: UIViewController {

    @IBOutlet weak var topLabel: UINavigationItem!
    @IBOutlet weak var discription: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var lineLeft: UIView!
    @IBOutlet var lineRight: UIView!
    @IBOutlet weak var backAndNextButton: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var secondDisplay: Bool = false
    var startPoint: String!
    var endPoint: String!
    
    var minimumScheduleDate: Date!
    var maximumScheduleDate: Date!
    
    var detailSchedule: Schedule!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.title = "\(detailSchedule.startPoint!) - \(detailSchedule.endPoint!)"
        //dataPickerの最小値、最大値を設定
        minimumScheduleDate = DateUtils.dateFromString(string: detailSchedule.startPoint)
        maximumScheduleDate = DateUtils.dateFromString(string: detailSchedule.endPoint)
        
        datePicker.minimumDate = minimumScheduleDate
        datePicker.maximumDate = maximumScheduleDate
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        //ラベルを選択した日付にする
        if secondDisplay == false {
            startPoint = DateUtils.stringFromDate(date: sender.date)
            label.text = startPoint
        } else {
            endPoint = DateUtils.stringFromDate(date: sender.date)
            label.text = endPoint
        }
    }
    
    @IBAction func next(_ sender: Any) {
        //startpoint定めていたら画面デザイン変える
        if startPoint != nil {
            //次の画面に遷移した証
            secondDisplay = !secondDisplay
            //ボタンを非表示&表示
            nextButton.isHidden = true
            backAndNextButton.isHidden = false
            //線の位置を変える
            lineRight.isHidden = true
            lineLeft.isHidden = false
            //説明文変える
            discription.text = "予定の終了日を選択してください。"
            //ラベルリセット
            label.text = " "
            //datePickerの最小値を設定
            datePicker.minimumDate = DateUtils.dateFromString(string: startPoint)
            
        } else {
            print("notdoneyet!")
        }
    }
    
    @IBAction func done(_ sender: Any) {
        if endPoint != nil {
          toResultView()
        } else {
            print("まだやで")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        //前に戻った証
        secondDisplay = !secondDisplay
        //ボタンを非表示&表示
        nextButton.isHidden = false
        backAndNextButton.isHidden = true
        //線の位置を変える
        lineRight.isHidden = false
        lineLeft.isHidden = true
        //説明文変える
        discription.text = "予定の開始日を選択してください。"
        //ラベルリセット
        label.text = startPoint
        //datePickerをstartPointにする
        datePicker.date = DateUtils.dateFromString(string: startPoint)
        //datePickerの最小値をリセット
        datePicker.minimumDate = minimumScheduleDate
        //endpointをnil
        endPoint = nil
    }
    
    func toResultView() {
        performSegue(withIdentifier: "toResultPlanView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultPlanView = segue.destination as! ResultPlanViewController
        resultPlanView.startPoint = self.startPoint
        resultPlanView.endPoint = self.endPoint
        resultPlanView.detailSchedule = self.detailSchedule
    }
    


}
