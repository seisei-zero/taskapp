//
//  InputViewController.swift
//  taskapp
//
//  Created by 林正悟 on 2020/05/29.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
//このimportはclassを呼べるようにしている？？？？？？？？？？？？？？？？？？？？？？？？？？


class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextview: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    let realm = try! Realm()
    var task: Task!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
//上記の()内にtapGestureを入れることでUITapGestureRecognizerを動させている？addGestureRecognizerでtap先をviewにしている？？？？
        titleTextField.text = task.title
        contentsTextview.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextview.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text!
//categoryプロパティへの書き込む値の代入
            self.realm.add(self.task, update: .modified)
    }
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    func setNotification(task: Task){
//上記のメソッドの引数(task)は設定しないといけないのか(上で一度宣言しているのに)？？？？？？？？？？？？？？？？？？？？？？？？？？
        let content = UNMutableNotificationContent()
        
        if task.title == ""{
            content.title = "(タイトルなし)"
//通知内容のタイトルを設定
        }else{
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "(内容なし)"
        }else{
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        let calendar = Calendar.current
//currentとは？これで現在のuserの時間情報を取得したという事で良い？？？？？？？？？？？？？？？？
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
//日付や時間を取得
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//triggerの形を設定している？？？？？？？？？？？？？？？？？？？？？？？？？？
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
//通知するcellの特定、設定し直したcontentインスタンスの当てはめ、設定したtriggerの当てはめる
        let center = UNUserNotificationCenter.current()
        center.add(request) {
            (error) in
            print(error ?? "ローカル通知登録　OK")
        }
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest])in
            for request in requests{
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
