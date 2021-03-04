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
        nextButton.isHidden = true
        backAndNextButton.isHidden = false
        //線の位置を変える
        lineRight.isHidden = true
        lineLeft.isHidden = false
        //説明文変える
        discription.text = "スケジュールの終了日を選択してください。"
        //ラベルリセット
        label.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        //datePickerの最小値を設定
        datePicker.minimumDate = startPoint
        
    }
    
    @IBAction func done(_ sender: Any) {
        toResultView()
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
