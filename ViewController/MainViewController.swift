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
    var currentSchedules: [Schedule] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ScheduleViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleViewCell")
        
//        print(UserDefaults.standard.dictionaryRepresentation().filter { $0.key.hasPrefix("schedules") })
        
        currentSchedules = database.schedules

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        database = Database()
        tableView.reloadData()
        
        if currentSchedules.count == 0 {
            
            let image = UIImageView(image:  UIImage(systemName: "arrow.down"))
            image.frame = CGRect(x: self.view.frame.width / 2 - 25, y: self.view.frame.height - 160, width: 50, height: 60)
            image.tintColor = UIColor.black
            
            let text = UILabel()
            text.text = "カレンダーを追加してください。"
            text.textColor =  UIColor.black
            text.frame.size = CGSize(width: 300, height: 100)
            text.textAlignment = NSTextAlignment.center
            text.center = CGPoint(x: self.view.frame.width / 2 , y: self.view.frame.height - 170)
            
            self.view.addSubview(image) // ラベルの追加
            self.view.addSubview(text)
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
                    image.center.y += 20.0
                }) { _ in
                    image.center.y -= 20.0
                }

            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleViewCell", for: indexPath) as! ScheduleViewCell
        
        cell.setCell(schedule: currentSchedules[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            print("flu")
        } else {
            detailSchedule = database.schedules[indexPath.row]
            performSegue(withIdentifier: "toDetailView", sender: nil)
        }
    }
    
    //並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let schedule = currentSchedules[sourceIndexPath.row]
        //database
        schedule.changeOrder(destinationIndex: destinationIndexPath.row)
        
        currentSchedules.remove(at: sourceIndexPath.row)
        currentSchedules.insert(schedule, at: destinationIndexPath.row)
        
    }
    
    //editingstyleおよびスワイプにおける削除機能の追加
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 先にデータを削除しないと、エラーが発生します。
        //DB削除
        //schedule
        let willDeleteSchedule = database.schedules.first( where: { $0.id == currentSchedules[indexPath.row].id })
        willDeleteSchedule?.delete()
        
        //plan
        let willDeletePlan = database.plans.filter({ $0.scheduleID == currentSchedules[indexPath.row].id })
        for (n,_) in willDeletePlan.enumerated() {
            willDeletePlan[n].delete()
        }
        //ローカル削除
        currentSchedules.remove(at: indexPath.row)
        
        //見た目削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //ローカル変数更新
        currentSchedules = database.schedules
    }
    
    //削除ラベルのタイトルを変える
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除する"
    }
    
    //編集ボタン
    @IBAction func editButton() {
        if isEditing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButton))
            navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
        } else {
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "完了", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButton))
            navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        }
//        print(UserDefaults.standard.dictionaryRepresentation().filter { $0.key.hasPrefix("plans") })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let detailView = segue.destination as! DetailViewController
            detailView.detailSchedule = detailSchedule
        }
    }
    


}
