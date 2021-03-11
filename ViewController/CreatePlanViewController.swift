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
    var startPoint: Date!
    var endPoint: Date!
    
    var minimumScheduleDate: Date!
    var maximumScheduleDate: Date!
    
    var detailSchedule: Schedule!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.title = "\(DateUtils.stringFromDate(date: detailSchedule.startPoint!, format: "yyyy/MM/dd") ) - \(DateUtils.stringFromDate(date: detailSchedule.endPoint!, format: "yyyy/MM/dd") )"
        //dataPickerの最小値、最大値を設定
        minimumScheduleDate = detailSchedule.startPoint
        maximumScheduleDate = detailSchedule.endPoint
        
        datePicker.minimumDate = minimumScheduleDate
        datePicker.maximumDate = maximumScheduleDate
        
        datePicker.date = detailSchedule.startPoint
        startPoint = datePicker.date
        label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        
        //アニメーションするためにこれ入れる
        self.lineLeft.alpha = 0.0
        self.backAndNextButton.alpha = 0.0
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        //ラベルを選択した日付にする
        if secondDisplay == false {
            startPoint = sender.date
            label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        } else {
            endPoint = sender.date
            label.text = DateUtils.stringFromDate(date: endPoint, format: "yyyy/MM/dd")
        }
    }
    
    @IBAction func next(_ sender: Any) {
        //次の画面に遷移した証
        secondDisplay = !secondDisplay
        //アニメーション
        UIView.animate(withDuration: 0.1, animations: {
            self.nextButton.alpha = 0.0
        }, completion:  { _ in
            self.nextButton.isHidden = true
        })
        //falseにするやつは先
        self.backAndNextButton.isHidden = false
        self.lineLeft.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backAndNextButton.alpha = 1.0
            self.lineLeft.alpha = 1.0
            self.lineRight.alpha = 0.0
        }, completion:  { _ in
            self.lineRight.isHidden = true
        })
        //説明文変える
        discription.text = "予定の終了日を選択してください。"
        
        //datePickerの最小値を設定
        datePicker.minimumDate = startPoint
        
        datePicker.date = startPoint
        
        endPoint = startPoint
        
        label.text = DateUtils.stringFromDate(date: endPoint, format: "yyyy/MM/dd")
            
    }
    
    @IBAction func back(_ sender: Any) {
        //前に戻った証
        secondDisplay = !secondDisplay
        //ボタンを非表示&表示
        nextButton.isHidden = false
        lineRight.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.nextButton.alpha = 1.0
            self.lineLeft.alpha = 0.0
            self.lineRight.alpha = 1.0
            self.backAndNextButton.alpha = 0.0
        }, completion: { _ in
            self.lineLeft.isHidden = true
            self.backAndNextButton.isHidden = true
        })
        
        //説明文変える
        discription.text = "予定の開始日を選択してください。"
        //ラベルリセット
        label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        //datePickerをstartPointにする
        datePicker.date = startPoint
        //datePickerの最小値をリセット
        datePicker.minimumDate = minimumScheduleDate
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
