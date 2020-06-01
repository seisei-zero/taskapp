//
//  ViewController.swift
//  taskapp
//
//  Created by 林正悟 on 2020/05/28.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
//プロトコルを入れる事によりそのうちにあるデリゲートメソッド(アクションのどのタイミングでメソッドを入れるか等[フックするという])が使えるようになる
    
    @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var searchTextField: UITextField!
    
        let realm = try! Realm()
  //Taskクラスを指定してデータ一覧を取得している
    
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
//tableViewのデリゲート先を指定　このことによりViewController内でデリゲートメソッドが使えるようになる。
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        //もしidentifierが"cellSegue"であるsegueが行われたらという意味
        if segue.identifier == "cellSegue"{            //遷移先のtaskプロパティにTaskのインスタンスを渡す(選ばれたcellによってインスタンスの中身が変わっているかもしれないが)
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        }else{
            //初期値のTask(インスタンス)を代入しようとする
            let task = Task()
            //要素数(count)を知りたいためデータ一覧を取得する
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            //if taskArray.count != 0 {                task.id = taskArray.max(ofProperty: "id")! + 1 }ではダメなのか？？？？？？？？？？？？？？？？
            inputViewController.task = task
        }
    }
//下記のメソッドの()内は_(第一外部引数) tableView(第一内部引数): UITableView(型), numberOfRowsInSection(←これの役割は？第二外部引数？) section(第二内部引数？): Int(型)？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
//UITableView(型)を定義する意味は？？？？？？？？？？？？？？？？？？？？？？？
//内部引数を関数内で使わないのに設定する意味は？？？？？？？？？？？？？？？？？？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
//ここで返した要素分だけfunc tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCellのメソッドが繰り返し行われる
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //withIdentifierはTable View CellのユーティリティエリアのIdentifierに繋がっている
//ここにおけるindexPathとはセルの数分だけの通し番号を示しており、今回taskArray.countが3つセルを返していたので0,1,2と三回に分けて行われているつまりindexPathとは投資番号0,1,2それぞれのことである。
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      //いまいちindexPathで何をしているのか不明　メソッドdequeueReusableCellの第二外部引数(for)に代入しているという事でいいのか？？？？？？？？？？？
                let task = taskArray[indexPath.row]
        print(indexPath.row)
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
//後にsegueの遷移の仕方により渡し値を変更する
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = self.taskArray[indexPath.row]
//いまいちindexPathが何の機能を表しているのかわからない、選択しているものを表しているとしたらユーザーの選択アクションを受け取る(認知するものは何かそれがindexPathなのか？？？？？？？let indexPath = self.tableView.indexPathForSelectedRowは入れなくても良いのか)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            try! realm.write{ self.realm.delete(task)
//.deleteメソッドがエラーになる可能性があるため、try!を用いた。
                              tableView.deleteRows(at: [indexPath], with: .fade)
            }
            center.getPendingNotificationRequests{
                (requests: [UNNotificationRequest])in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let realm = try! Realm()
        if searchTextField.text == nil{
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        }else{
            taskArray = realm.objects(Task.self).filter("category == %@",searchTextField.text!)
            print("category == \( searchTextField.text!)")
        }
        tableView.reloadData()
        
//データ一覧を取得してカテゴリーで絞り込み　.objects(Task.self).filterは返り値を含む関数であるため何か変数に格納しなければならないその上、今回使用しない変数(_)を用いた←結局代入先が変数(_)はす廃棄と同義
        return true
    }
    
    
}


