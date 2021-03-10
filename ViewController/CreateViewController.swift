//
//  CreateViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit

class CreateViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPoint = Date()
        label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        
        //アニメーションするためにこれ入れる
        self.lineLeft.alpha = 0.0
        self.backAndNextButton.alpha = 0.0
        
        print(nextButton.tintColor!)
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        if secondDisplay == false {
            startPoint = sender.date
            label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        } else {
            endPoint = sender.date
            label.text = DateUtils.stringFromDate(date: endPoint, format: "yyyy/MM/dd")
        }
    }
    
   
    @IBAction func next(_ sender: Any) {
        //startpoint定めていたら画面デザイン変える
         //次の画面に遷移した証
        secondDisplay = !secondDisplay
        //ボタンを非表示&表示
        
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
        discription.text = "スケジュールの終了日を選択してください。"
        
        
        //datePickerの最小値を設定
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: startPoint)!
        
        //ラベルリセット
        label.text = DateUtils.stringFromDate(date: datePicker.minimumDate!, format: "yyyy/MM/dd")
        //それを登録
        endPoint = datePicker.minimumDate
        
    }
    
    @IBAction func done(_ sender: Any) {
        toResultView()
    }
    
    
    @IBAction func back(_ sender: Any) {
        //前に戻った証
        secondDisplay = !secondDisplay
        //ボタンを非表示&表示
        
        self.nextButton.isHidden = false
        self.lineRight.isHidden = false
        
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
        discription.text = "今から作成する\nスケジュールの開始日を選択してください。"
        //ラベルリセット
        label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        //datePickerをstartPointにする
        datePicker.date = startPoint
        //datePickerの最小値をリセット
        datePicker.minimumDate = nil
        
        
    }
    
    func toResultView() {
        performSegue(withIdentifier: "toResultView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultView = segue.destination as! ResultViewController
        resultView.startPoint = self.startPoint
        resultView.endPoint = self.endPoint
    }
    
}
