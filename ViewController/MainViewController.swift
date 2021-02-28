//
//  MainViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var database: Database!
    var detailSchedule: Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ScheduleViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleViewCell")
//        print(database.schedules)
//        print(UserDefaults.standard.dictionaryRepresentation().filter { $0.key.hasPrefix("schedules") })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        database = Database()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleViewCell", for: indexPath) as! ScheduleViewCell
        
        cell.setCell(schedule: database.schedules[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailSchedule = database.schedules[indexPath.row]
        performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let detailView = segue.destination as! DetailViewController
            detailView.detailSchedule = detailSchedule
        }
    }
    


}
