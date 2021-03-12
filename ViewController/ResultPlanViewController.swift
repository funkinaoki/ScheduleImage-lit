//
//  ResultPlanViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/28.
//

import UIKit

class ResultPlanViewController: UIViewController, UITextFieldDelegate {

    var delegate: EditPlanProtocol?
    
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var startPoint: Date!
    var endPoint: Date!
    var detailSchedule: Schedule!
    var distanceDate: Float!

    override func viewDidLoad() {
        super.viewDidLoad()
        startPointLabel.text = DateUtils.stringFromDate(date: startPoint, format: "yyyy/MM/dd")
        endPointLabel.text = DateUtils.stringFromDate(date: endPoint, format: "yyyy/MM/dd")
        
        nameTextField.delegate = self
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func create(_ sender: Any) {
        if nameTextField.text != "" {
            let calendar = Calendar(identifier: .gregorian)
            startPoint = DateDifferences.roundDate(startPoint, calendar: calendar)
            endPoint = DateDifferences.roundDate(endPoint, calendar: calendar)
            distanceDate = Float(DateDifferences.calcDateRemainder(firstDate: endPoint,
                                                                   secondDate: startPoint))
            
            let newPlan = Plan(name: nameTextField.text,
                               startPoint: startPoint,
                               endPoint: endPoint,
                               distanceDate: distanceDate,
                               scheduleID: detailSchedule.id)
            newPlan.save()
            
            let count = (self.navigationController?.viewControllers.count)! - 3
            let vcA = self.navigationController?.viewControllers[count]
            self.delegate = vcA as? EditPlanProtocol

            delegate?.updateUI()
            navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
        }
    }
    
    //キーボード
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }

   

}
