//
//  NavigationViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/06.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = CGFloat(100)
        let bounds = self.navigationBar.bounds
        navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    


}
