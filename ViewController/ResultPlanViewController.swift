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
    
    
    var startPoint: String!
    var endPoint: String!
    var detailSchedule: Schedule!

    override func viewDidLoad() {
        super.viewDidLoad()
        startPointLabel.text = startPoint
        endPointLabel.text = endPoint
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func create(_ sender: Any) {
        if nameTextField.text != "" {
            let newPlan = Plan(name: nameTextField.text, startPoint: startPoint, endPoint: endPoint, scheduleID: detailSchedule.id )
            newPlan.save()
            self.dismiss(animated: true, completion: nil)
        }
    }

    

   

}
