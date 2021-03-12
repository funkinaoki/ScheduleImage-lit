//
//  PlanDetailViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/05.
//

import UIKit



class PlanDetailViewController: UIViewController {
    
    var delegate: EditPlanProtocol?

    @IBOutlet weak var startPointLabel: UIButton!
    
    @IBOutlet weak var endPointLabel: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var plan: Plan!
    
    var startOrEnd: Bool!
    
    var detailSchedule: Schedule!
    var startPoint: Date!
    var endPoint: Date!
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPointLabel.setTitle(DateUtils.stringFromDate(date: plan.startPoint, format: "yy/MM/dd"), for: .normal)
        endPointLabel.setTitle(DateUtils.stringFromDate(date: plan.endPoint, format: "yy/MM/dd"), for: .normal)
        
        nameField.text = plan.name
        datePicker.isHidden = true
        startPoint = plan.startPoint
        endPoint = plan.endPoint
        database = Database()
        

    }
    
    @IBAction func startPointButton(_ sender: Any) {
        datePicker.date = startPoint
        datePicker.minimumDate = detailSchedule.startPoint
        datePicker.maximumDate = endPoint
        datePicker.isHidden = false
        startOrEnd = true
    }
    
    @IBAction func endPointButton(_ sender: Any) {
        datePicker.date = endPoint
        datePicker.minimumDate = startPoint
        datePicker.maximumDate = detailSchedule.endPoint
        datePicker.isHidden = false
        startOrEnd = false
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
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title:"確認", message: "削除してもよろしいでしょうか。", preferredStyle: .alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //DB削除
            //schedule
            let willDeletePlan = self.database.plans.first( where: { $0.id == self.plan.id })
            willDeletePlan?.delete()
            self.delegate?.updateUI()
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
    
    
    @IBAction func saveButton(_ sender: Any) {
        let calendar = Calendar(identifier: .gregorian)
        //日時を00:00にする
        startPoint = DateDifferences.roundDate(startPoint, calendar: calendar)
        endPoint = DateDifferences.roundDate(endPoint, calendar: calendar)
        plan.startPoint = startPoint
        plan.endPoint = endPoint
        plan.name = nameField.text
        plan.distanceDate = Float(DateDifferences.calcDateRemainder(firstDate: endPoint, secondDate: startPoint))
        plan.floor = 0
        plan.save()
        delegate?.updateUI()
        dismiss(animated: true, completion: nil)
        
    }
    
}

