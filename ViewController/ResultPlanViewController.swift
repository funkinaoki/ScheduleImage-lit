//
//  ResultPlanViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

class ResultPlanViewController: UIViewController {

    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var startPoint: Date!
    var endPoint: Date!
    var detailSchedule: Schedule!
    var distanceDate: Float!

    override func viewDidLoad() {
        super.viewDidLoad()
        startPointLabel.text = DateUtils.stringFromDate(date: startPoint)
        endPointLabel.text = DateUtils.stringFromDate(date: endPoint)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func create(_ sender: Any) {
        if nameTextField.text != "" {
            distanceDate = Float(Calendar.current.dateComponents([.day], from: startPoint, to: endPoint).day!)
            let newPlan = Plan(name: nameTextField.text, startPoint: startPoint, endPoint: endPoint, distanceDate: distanceDate, scheduleID: detailSchedule.id)
            newPlan.save()
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    

   

}
