//
//  ResultViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/27.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var startPoint: String!
    var endPoint: String!


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
            let newSchedule = Schedule(name: nameTextField.text, startPoint: startPoint, endPoint: endPoint)
            newSchedule.save()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
