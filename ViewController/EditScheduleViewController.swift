//
//  EditScheduleViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/10.
//

import UIKit

class EditScheduleViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: EditScheduleProtocol?

    @IBOutlet weak var startPointLabel: UIButton!
    @IBOutlet weak var endPointLabel: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startOrEnd: Bool!
    
    var detailSchedule: Schedule!
    var startPoint: Date!
    var endPoint: Date!
    
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        
        startPointLabel.setTitle(DateUtils.stringFromDate(date: detailSchedule.startPoint, format: "yy/MM/dd"), for: .normal)
        endPointLabel.setTitle(DateUtils.stringFromDate(date: detailSchedule.endPoint, format: "yy/MM/dd"), for: .normal)
        titleField.text = detailSchedule.name
        
        
        datePicker.isHidden = true
        startPoint = detailSchedule.startPoint
        endPoint = detailSchedule.endPoint
        titleField.delegate = self

    }
    
    @IBAction func datePicker(_ sender: Any) {
        if startOrEnd==true {
            startPointLabel.setTitle(DateUtils.stringFromDate(date: datePicker.date, format: "yy/MM/dd"), for: .normal)
            startPoint = datePicker.date
        } else {
            endPointLabel.setTitle(DateUtils.stringFromDate(date: datePicker.date, format: "yy/MM/dd"), for: .normal)
            endPoint = datePicker.date
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        datePicker.date = startPoint
        datePicker.minimumDate = nil
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: endPoint)!
        datePicker.isHidden = false
        startOrEnd = true
    }
    
    @IBAction func endButton(_ sender: Any) {
        datePicker.date = endPoint
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: startPoint)!
        datePicker.maximumDate = nil
        datePicker.isHidden = false
        startOrEnd = false
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let calendar = Calendar(identifier: .gregorian)
        //日時を00:00にする
        startPoint = DateDifferences.roundDate(startPoint, calendar: calendar)
        endPoint = DateDifferences.roundDate(endPoint, calendar: calendar)
        detailSchedule.startPoint = startPoint
        detailSchedule.endPoint = endPoint
        detailSchedule.name = titleField.text
        detailSchedule.save()
        delegate?.viewDidDismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title:"確認", message: "削除してもよろしいでしょうか。", preferredStyle: .alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //DB削除
            //schedule
            let willDeleteSchedule = self.database.schedules.first( where: { $0.id == self.detailSchedule.id })
            willDeleteSchedule?.delete()
            
            //plan
            let willDeletePlan = self.database.plans.filter({ $0.scheduleID == self.detailSchedule.id })
            for (n,_) in willDeletePlan.enumerated() {
                willDeletePlan[n].delete()
            }
            self.delegate?.viewDidDismiss()
            self.dismiss(animated: true, completion: nil)

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
    }

}
