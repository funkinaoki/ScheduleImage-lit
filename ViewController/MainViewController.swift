//
//  MainViewController.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/02/26.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditScheduleProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var database: Database!
    var detailSchedule: Schedule!
    var currentSchedules: [Schedule] =  []
    var image = UIImageView(image:  UIImage(systemName: "arrow.down"))
    var text = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ScheduleViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleViewCell")
        tableView.allowsSelectionDuringEditing = true
//        tableView.estimatedRowHeight = 128
//        tableView.rowHeight = UITableView.automaticDimension
        
        //アニメーションの部品
        
        image.tintColor = UIColor.black
        image.frame.size = CGSize(width: 50, height: 60)
        image.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 123)
        
        text.text = "スケジュールを追加してください。"
        text.textColor =  UIColor.black
        text.textAlignment = NSTextAlignment.center
        text.frame.size = CGSize(width: 300, height: 100)
        text.center = CGPoint(x: self.view.frame.width / 2 + 10, y: self.view.frame.height - 160)
        
        
        self.view.addSubview(image) // ラベルの追加
        self.view.addSubview(text)
        
        animateArrow()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        database = Database()
        currentSchedules = database.schedules
        tableView.reloadData()
        super.setEditing(false, animated: true)
        tableView.setEditing(false, animated: true)
        print(isEditing)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        if currentSchedules.count == 0 {
            print("true")
            image.alpha = 1.0
            text.alpha = 1.0
        } else {
            image.alpha = 0.0
            text.alpha = 0.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleViewCell", for: indexPath) as! ScheduleViewCell
        
        cell.setCell(schedule: currentSchedules[indexPath.row])
        // 選択された背景色を白に設定
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = cellSelectedBgView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //受け渡しで使います
        detailSchedule = database.schedules[indexPath.row]
        if isEditing {
            performSegue(withIdentifier: "toEditScheduleView", sender: nil)
        } else {
            performSegue(withIdentifier: "toDetailView", sender: nil)
        }
    }
    
    //並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let schedule = currentSchedules[sourceIndexPath.row]
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
        //アニメーション
        viewWillAppear(true)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let detailView = segue.destination as! DetailViewController
            detailView.detailSchedule = detailSchedule
        }
        if segue.identifier == "toEditScheduleView" {
            let detailView = segue.destination as! EditScheduleViewController
            detailView.delegate = self
            detailView.detailSchedule = detailSchedule
        }
    }
    func animateArrow() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat,.autoreverse] , animations: {
            self.image.center.y += 10.0
            }, completion: { finished in
                self.animateArrow()
        })
    }
    
    //プロトコルポップアップはviewwillappear呼ばれないから
    func viewDidDismiss() {
        viewWillAppear(true)
    }
}
