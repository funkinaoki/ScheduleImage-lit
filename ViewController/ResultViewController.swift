//
//  ResultViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

class ResultViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var startPoint: Date!
    var endPoint: Date!


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
            let newSchedule = Schedule(name: nameTextField.text,
                                       startPoint: DateDifferences.roundDate(startPoint, calendar: calendar),
                                       endPoint: DateDifferences.roundDate(endPoint, calendar: calendar))
            newSchedule.save()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
}
